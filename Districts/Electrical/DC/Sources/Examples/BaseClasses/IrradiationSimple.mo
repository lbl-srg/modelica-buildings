within Districts.Electrical.DC.Sources.Examples.BaseClasses;
model IrradiationSimple "Simple abstract model for solar irradiation"

  Modelica.Blocks.Interfaces.RealOutput solarIrradiation(final quantity="RadientEnergyFluenceRate",final unit="W/m2")
    annotation (Placement(transformation(extent={{92,-12},{112,8}})));

  parameter Modelica.SIunits.RadiantEnergyFluenceRate maxlimit = 600
    "maximal solar irradiation";

protected
  Real x_;
  constant Real halfday = 60 * 60 * 12;

equation
  x_ = sin(Modelica.Constants.pi * time / halfday);
  solarIrradiation = if x_ > 0 then x_ * maxlimit else 0;

end IrradiationSimple;
