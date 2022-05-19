within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record ExteriorWallCase680 =
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
        x=0.25,
        k=0.040,
        c=1400,
        d=10,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.012,
        k=0.160,
        c=840,
        d=950,
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Low Mass Case 680 with increased insulation"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaCon",
  Documentation(info="<html>
<p>
This construction is for the exterior wall of the Case 680.
</p>
</html>"));
