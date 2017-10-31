within Buildings.Controls.OBC.CDL.Types;
type Smoothness = enumeration(
    LinearSegments "Table points are linearly interpolated",
    ConstantSegments
      "Table points are not interpolated, but the previous tabulated value is returned")
  "Enumeration defining the smoothness of table interpolation";
