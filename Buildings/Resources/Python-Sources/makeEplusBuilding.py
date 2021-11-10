import re
from pathlib import Path
from typing import List, Union, Tuple

import numpy as np
from dataclasses import dataclass

"""
The main usage of the functions in this file are to read, scale and write energyplus models that
have been manually templated to be scaled to N number of floors.
The templated raw idf contains anchors {mid} and {top} to identify objects that are specific to 
middle and top floors, and the function scale_building_template is used to find these anchors,
multiply middle floors and their components (zones, lights, loads, envelope) and inform the 
coordinates of new middle floors and top floor.

See Buildings/Resources/Data/Examples/ZoneScaling/raw/RefBldgLargeOfficeNew2004_Chicago_template.idf
for an example of a template.

The typical process for creating a new scaled model is:
    template = read_idf(template_path)
    scaled = scale_building_template(template, floor_count)
    write_idf(scaled, output_path)
"""

IDF_CHAR_LIMIT = 100
FLOOR_TO_FLOOR_HEIGHT = 3.9632  # 13ft floor to floor
FLOOR_TO_CEILING_HEIGHT = 2.744

EnergyPlusObject = List[str]
EnergyPlusModel = List[EnergyPlusObject]
Coordinates = Tuple[float, float, float]


@dataclass
class ReplaceablePattern:
    id: str
    floor: str
    plenum: str

    def sub_patterns(
        self, line: str, floor: int,
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


def read_idf(path: Union[Path, str]) -> EnergyPlusModel:
    """
    Read an IDF file from a path and return a parsed list of IDF objects.
    """
    raw = Path(path).read_text(encoding="cp1252").split("\n")
    # Filter comments and trailing spaces and combine into a single string
    combined = "".join([re.sub("!.*$", "", line).strip() for line in raw])
    # Split by individual object and then split individual values from objects
    return [line.split(",") for line in combined.split(";")[:-1]]


def write_idf(model: EnergyPlusModel, path: Union[Path, str]) -> None:
    """
    Format an energyplus model into an IDF and write its content to path.
    """

    def _try_format_float(v: str) -> str:
        # Format float values to 6 decimal points and remove trailing zeroes.
        try:
            return np.format_float_positional(
                float(v), precision=6, unique=False, fractional=False, trim="0"
            )
        except ValueError:
            return v

    def _compact_line(object: EnergyPlusObject) -> List[str]:
        # Insert line break in lines that are over the IDF character limit (100)
        compact_lines = []
        raw_line = ",".join([_try_format_float(v) for v in object]) + ";"
        while len(raw_line) > IDF_CHAR_LIMIT:
            i = IDF_CHAR_LIMIT - 1
            last_string_pos = IDF_CHAR_LIMIT - raw_line[i::-1].find(",")
            compact_lines.append(raw_line[:last_string_pos])
            raw_line = raw_line[last_string_pos:]
        compact_lines.append(raw_line)
        return compact_lines

    idf = [line for object in model for line in _compact_line(object)]
    Path(path).write_text("\n".join(idf))


def scale_building_template(
    model: EnergyPlusModel, floor_count: int, only_mid: bool = False
):
    """
    Take a templated EnergyPlusModel (i.e. with anchors) and scale it to the specified number of 
    floors by multiplying the number of middle floor.
    The flag only_mid removes the bottom and top floor so that resulting model only has identical
    floors with adiabatic floor and ceiling.
    """

    def _remove_objects(model: EnergyPlusModel, patterns: List[str]):
        # Remove all idf lines which contains at least one of the pattern in the list
        def _match_pattern(object: EnergyPlusObject):
            return np.logical_or.reduce(
                [re.search(pattern, ",".join(object)) for pattern in patterns]
            )

        return [object for object in model if not _match_pattern(object)]

    if floor_count < 2:
        raise ValueError(
            f"Invalid floor counts, at least 2 floors required. {floor_count} < 2"
        )

    if only_mid:
        model = _remove_objects(model, ["fl0", TOP_FLOOR_PATTERN.id, "Basement"])
        mid_floor_range = range(floor_count)
    else:
        mid_floor_range = range(1, floor_count - 1)

    output = []
    for object in model:
        line = ",".join(object)
        # Duplicates every object with a "mid" anchor
        if re.search(MID_FLOOR_PATTERN.id, line):
            for i in mid_floor_range:
                output.append(MID_FLOOR_PATTERN.sub_patterns(line, i).split(","))
        # Replace patters if object is top-floor related
        elif re.search(TOP_FLOOR_PATTERN.id, line):
            output.append(TOP_FLOOR_PATTERN.sub_patterns(line, floor_count - 1).split(","))
        else:
            output.append(object)

    return output


def offset_surfaces_coordinates(model: EnergyPlusModel) -> EnergyPlusModel:
    """
    Helper function to prepare idf template.

    Find and offset coordinates of zones and surfaces from an absolute coordinate system (with a 
    single origin point for the whole building) to a relative coordinate system where each zone and
    associated surfaces has its own origin point.
    This simplify the scaling and multiplication of floors by only having to update new zones 
    origins rather than the coordinates of all duplicated objects.
    """

    def _get_origin(vertices: List[str]) -> Coordinates:
        vertices = [float(v) for v in vertices]
        return min(vertices[0::3]), min(vertices[1::3]), min(vertices[2::3])

    def _offset_vertices(
        vertices: List[str], origin: Coordinates, reverse: bool = False
    ) -> List[str]:
        vertices = np.array([float(v) for v in vertices])
        k = -1 + reverse * 2  # -1 for False, 1 for True
        for i in range(3):
            vertices[i::3] += k * origin[i]

        return list(vertices.astype(str))

    zones, windows, walls = {}, {}, {}
    output: EnergyPlusModel = []

    for object in model:
        obj_type = object[0]
        if obj_type == "Zone":
            zones[object[1]] = object
        elif obj_type == "FenestrationSurface:Detailed":
            windows[object[1]] = object
        elif obj_type == "BuildingSurface:Detailed":
            walls[object[1]] = object
        else:
            output.append(object)

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

    return output + [obj_dict.values() for obj_dict in [zones, walls, windows]]
