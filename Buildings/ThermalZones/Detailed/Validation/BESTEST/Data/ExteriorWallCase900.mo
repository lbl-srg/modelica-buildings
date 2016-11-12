within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record ExteriorWallCase900 =
    Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009,
        k=0.140,
        c=900,
        d=530,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0615,
        k=0.040,
        c=1400,
        d=10,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.100,
        k=0.510,
        c=1000,
        d=1400,
        nStaRef=nStaRef)}) "High Mass Case: Exterior Wall"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaCon",
  Documentation(info="<html>
<p>
This construction is for the exterior wall of the 900 test series.
</p>
</html>"));
