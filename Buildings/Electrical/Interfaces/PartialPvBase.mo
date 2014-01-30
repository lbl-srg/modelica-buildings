within Buildings.Electrical.Interfaces;
partial model PartialPvBase
  parameter Modelica.SIunits.Area A "Net surface area";
  parameter Real fAct(min=0, max=1, unit="1") = 0.9
    "Fraction of surface area with active solar cells";
  parameter Real eta(min=0, max=1, unit="1") = 0.12
    "Module conversion efficiency";
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Generated power"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
end PartialPvBase;
