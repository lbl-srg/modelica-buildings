within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record RoofCase680 =  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.019,
        k=0.140,
        c=900,
        d=530,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.4,
        k=0.040,
        c=840,
        d=12,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.010,
        k=0.160,
        c=840,
        d=950,
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Low mass Case 680 with increased roof insulation"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaCon",
  Documentation(info="<html>
<p>
This construction is for the roof of the Case 680.
</p>
</html>"));
