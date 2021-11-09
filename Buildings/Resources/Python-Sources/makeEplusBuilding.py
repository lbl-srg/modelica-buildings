import re
from pathlib import Path
from typing import List, Union, Tuple

import numpy as np
from dataclasses import dataclass

IDF_CHAR_LIMIT = 100
FLOOR_TO_FLOOR_HEIGHT = 3.9632  # 13ft floor to floor
FLOOR_TO_CEILING_HEIGHT = 2.744

# TODO : Write docs about these utils, but to summarize:
# - Use read_idf on the template (in Resources/Data/ThermalZones/EnergyPlus/Validation/ScalableLargeOffice/raw/)
# - Use scale_building_template to scale the parsed IDF to N number of floors
# - Save the results with write_idf in the resources folder of your choice


@dataclass
class ReplaceablePattern:
    id: str
    floor: str
    plenum: str

    def sub_patterns(
        self,
        line: str,
        floor: int,
    ):
        floor_elevation = FLOOR_TO_FLOOR_HEIGHT * floor

        out = re.sub(self.id, f"fl{floor}", line)
        out = re.sub(self.floor, str(floor_elevation), out)
        out = re.sub(self.plenum, str(floor_elevation + FLOOR_TO_CEILING_HEIGHT), out)
        return out


MID_FLOOR_PATTERN = ReplaceablePattern(
    id="\{mid\}", floor="\{midZ\}", plenum="\{midZP\}"
)
TOP_FLOOR_PATTERN = ReplaceablePattern(
    id="\{top\}", floor="\{topZ\}", plenum="\{topZP\}"
)

Coordinates = Tuple[float, float, float]


def _parse_line(idf_line: str) -> List[str]:
    split_line = idf_line.split(",")
    if len(split_line[-1]) > 0 and split_line[-1][-1] == ";":
        # Remove trailing ; from last value in object
        split_line[-1] = split_line[-1][:-1]
    return split_line


def _unparse_line(idf_object: List[str]) -> str:
    idf_object[-1] = idf_object[-1] + ";"
    return ",".join(idf_object)


def _format_float(v):
    return np.format_float_positional(
        v, precision=6, unique=False, fractional=False, trim="0"
    )


def read_idf(idf_path: Union[Path, str]) -> List[str]:
    def _to_float_to_string(v: str) -> str:
        # Make a string to float to string again to remove superfluous 0
        try:
            return _format_float(float(v))
        except ValueError:
            return v

    raw_idf = Path(idf_path).read_text(encoding="cp1252").split("\n")

    # IDF parsing turns the raw idf file (list of lines in the IDF) into a list
    # where each item is a single EnergyPlus object.

    # Remove comments, leading and trailing spaces
    parsed_idf = [re.sub("!.*$", "", line).strip() for line in raw_idf]
    # Join entire list into a single string
    combined_idf = "".join(parsed_idf)
    # Split Eplus objects
    split_idf = [line for line in combined_idf.split(";")[:-1]]
    # Strips trailing zeros in float values (mostly an aesthetic feature), and add trailing ;
    stripped_idf = [
        _unparse_line([_to_float_to_string(obj) for obj in _parse_line(line)])
        for line in split_idf
    ]
    return stripped_idf


def write_idf(idf_lines: List[str], idf_path: Union[Path, str]) -> None:
    def _compact_line(line: str, lim: int = IDF_CHAR_LIMIT) -> List[str]:
        compact_lines = []
        while len(line) > lim:
            i = lim - 1
            last_string_pos = lim - line[i::-1].find(",")
            compact_lines.append(line[:last_string_pos])
            line = line[last_string_pos:]
        compact_lines.append(line)
        return compact_lines

    limited_idf = [c_line for line in idf_lines for c_line in _compact_line(line)]
    Path(idf_path).write_text("\n".join(limited_idf))


def offset_surfaces_coordinates(idf: List[str]) -> List[str]:
    def _get_origin(vertices: List[str]) -> Coordinates:
        vertices = [float(v) for v in vertices]
        return min(vertices[0::3]), min(vertices[1::3]), min(vertices[2::3])

    def _offset_vertices(
        vertices: List[str], origin: Coordinates, reverse: bool = False
    ) -> List[str]:
        vertices = np.array([float(v) for v in vertices])
        k = -1 + reverse * 2  # -1 for False, 1 for True
        for i in range(3):
            vertices[i::3] = [_format_float(v) for v in vertices[i::3] + k * origin[i]]

        return list(vertices.astype(str))

    zones, windows, walls = {}, {}, {}
    output = []

    for line in idf:
        parsed_line = _parse_line(line)
        obj_type = parsed_line[0]
        if obj_type == "Zone":
            zones[parsed_line[1]] = parsed_line
        elif obj_type == "FenestrationSurface:Detailed":
            windows[parsed_line[1]] = parsed_line
        elif obj_type == "BuildingSurface:Detailed":
            walls[parsed_line[1]] = parsed_line
        else:
            output.append(line)

    zone_origins = {}

    # Find the origin of all zones
    for wall in walls.values():
        zone_name = wall[4]
        wall_origin = _get_origin(wall[11:])
        if zone_name in zone_origins:
            zone_origins[zone_name] = tuple(
                np.minimum(zone_origins[zone_name], wall_origin)
            )
        else:
            zone_origins[zone_name] = wall_origin

    for zone_name, zone in zones.items():
        if zone_name in zone_origins:
            zone[3:6] = _offset_vertices(zone[3:6], zone_origins[zone_name], True)

    for wall in walls.values():
        zone_name = wall[4]
        if zone_name in zone_origins:
            wall[11:] = _offset_vertices(wall[11:], zone_origins[zone_name])

    for window in windows.values():
        zone_name = walls[window[4]][4]
        if zone_name in zone_origins:
            window[10:] = _offset_vertices(window[10:], zone_origins[zone_name])

    unparsed_objs = [
        _unparse_line(obj)
        for obj_dict in [zones, walls, windows]
        for obj in obj_dict.values()
    ]

    return output + unparsed_objs


def _remove_objects(idf: List[str], patterns: List[str]):
    # Remove all idf lines which contains at least one of the pattern in the list
    def _match_pattern(line: str):
        return np.logical_or.reduce([re.search(pattern, line) for pattern in patterns])
    return [line for line in idf if not _match_pattern(line)]


def scale_building_template(idf: List[str], floor_count: int, only_mid: bool = False):
    if floor_count < 2:
        raise ValueError(
            f"Invalid floor counts, at least 2 floors required. {floor_count} < 2"
        )

    if only_mid:
        idf = _remove_objects(idf, ["fl0", TOP_FLOOR_PATTERN.id, "Basement"])
        mid_floor_range = range(floor_count)
    else:
        mid_floor_range = range(1, floor_count - 1)

    output = []
    for line in idf:
        # Duplicates every object with a "mid" anchor
        if re.search(MID_FLOOR_PATTERN.id, line):
            for i in mid_floor_range:
                output.append(MID_FLOOR_PATTERN.sub_patterns(line, i))
        else:
            # Sub patterns for "top" for all other lines.
            # This doesn't affect lines without the anchor.
            output.append(TOP_FLOOR_PATTERN.sub_patterns(line, floor_count - 1))

    return output
