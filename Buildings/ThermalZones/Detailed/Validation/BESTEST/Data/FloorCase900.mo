within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record FloorCase900 = Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
    final nLay=2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=1.007,
        k=0.040,
        c=0,
        d=0,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.080,
        k=1.130,
        c=1000,
        d=1400,
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough) "High Mass Case: Floor"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaCon",
  Documentation(info="<html>
<p>
This construction is for the floor of the 900 test series.
</p>
</html>"));
