from ansible.errors import AnsibleFilterError
from bisect import bisect_left
from re import compile


class FilterModule(object):
    def filters(self):
        return {
            "hana_storage_pools": build_storage_role_var,
            "hana_os_volumes": build_os_volumes_var,
        }


def build_storage_role_var(server_vols, sid, pvc_config):

    hana_filesystems = pvc_config["hana_filesystems"]
    hana_vol_filter = pvc_config["hana_vol_filter"].format(sid.lower())
    hana_vol_pattern = compile(hana_vol_filter)

    vg = {}
    for vol in server_vols:
        m = hana_vol_pattern.search(vol["name"])
        if m:
            hana_fs = m.group(1)
            vg_name = hana_filesystems[hana_fs]["vgname"].format(sid.lower())

            if vg_name not in vg:
                vg[vg_name] = {"size": 0, "wwns": [], "device_count": 0, "hana_fs": hana_fs}
            vg[vg_name]["size"] += vol["size"]
            vg[vg_name]["wwns"] += [vol["wwn"]]
            vg[vg_name]["device_count"] += 1

    storage_pools = []
    for vg_name in vg:
        hana_fs = vg[vg_name]["hana_fs"]
        pvs = ["/dev/mapper/3" + w.lower() for w in vg[vg_name]["wwns"]]
        # vg_device_count = vg[vg_name]["device_count"]
        lv_name = hana_filesystems[hana_fs]["lvname"].format(sid.lower())
        # lv_size = str(vg[vg_name]["size"] * 1024 - 16) + " MiB"
        lv_size = "100%"

        lv_attrs = {
            "name": lv_name,
            "type": "lvm",
            "state": "present",
            "size": lv_size,
            "fs_type": hana_filesystems[hana_fs]["fstype"],
            "mount_point": hana_filesystems[hana_fs]["mount"].format(sid.upper()),
        }

        # if vg_device_count > 1:
        #    lv_raid_attrs = {
        #        "raid_level": pvc_config["raid_level"],
        #        #"raid_chunk_size": pvc_config["raid_chunk_size"],
        #        #"raid_device_count": vg_device_count,
        #        "raid_disks": pvs,
        #    }
        #    # merge standard and raid attributes
        #    lv_attrs = {**lv_attrs, **lv_raid_attrs}

        volumes = [lv_attrs]

        stg_pool = {
            "name": vg_name,
            "type": "lvm",
            "disks": pvs,
            "volumes": volumes,
        }

        storage_pools += [stg_pool]

    return storage_pools


def calculate_fs_sizes(mem_size, pvc_config):

    hana_fs = {}
    pv_sizes = pvc_config["pv_size_choices"]
    pv_qtys = pvc_config["pv_qty_choices"]

    fs_sizes = {
        "log": (lambda x: min(x * 0.5, 512)),
        "data": (lambda x: x * 1.0),
        "shared": (lambda x: min(x, 1024)),
        "usrsap": (lambda x: 50),
        "backup": (lambda x: x * 1.0),
    }
    for fs in pvc_config["hana_filesystems"]:
        hana_fs[fs] = {}
        fs_size = int(-(-fs_sizes[fs](mem_size) // 1))  # round up to next integer
        if fs_size > pvc_config["max_fs_size"]:
            raise AnsibleFilterError(
                "File system size %d GiB exceeds maximum size of %d GiB"
                % (fs_size, pvc_config["max_fs_size"])
            )
        hana_fs[fs]["fs_size"] = fs_size
        default_pv_qty = pvc_config["pv_qty_default"][fs]
        index = bisect_left(pv_qtys, default_pv_qty)
        for pv_qty in pv_qtys[index:]:
            pv_size = fs_size / pv_qty
            if pv_size > pv_sizes[-1]:
                continue
            adjusted_pv_size = pv_sizes[bisect_left(pv_sizes, pv_size)]
            hana_fs[fs]["pv_qty"] = pv_qty
            hana_fs[fs]["pv_size"] = adjusted_pv_size
            break

    return hana_fs


def build_os_volumes_var(mem_size, vol_name_prefix, pvc_config):

    hana_fs = calculate_fs_sizes(mem_size, pvc_config)

    hana_vols = []
    for fs, fs_attr in pvc_config["hana_filesystems"].items():
        pv_size = hana_fs[fs]["pv_size"]
        for vol_no in range(1, hana_fs[fs]["pv_qty"] + 1):
            vol_name = fs_attr["volname"].format(vol_name_prefix, str(vol_no))
            hana_vols += [{"name": vol_name, "size": pv_size}]

    return hana_vols
