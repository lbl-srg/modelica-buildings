within Buildings.Examples.DistrictReservoirNetworks.Agents.Controls;
block HeatingCurve "Reset of heating supply and return set point temperatures"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Temperature THeaSup_nominal
    "Supply temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaRet_nominal
    "Return temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaSupZer
    "Minimum supply and return water temperature at zero load"
    annotation (Dialog(group="Nominal conditions"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(min=0, unit="1")
    "Heating load, normalized with peak load"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSup
  "Set point temperature for heating supply"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaRet
    "Set point temperature for heating return"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
initial equation
  assert(THeaSupZer < THeaRet_nominal, "THeaSupZer must be lower than THeaRet_nominal.");
equation
  THeaSup = THeaSupZer + u * (THeaSup_nominal - THeaSupZer);
  THeaRet = THeaSupZer + u * (THeaRet_nominal - THeaSupZer);
end HeatingCurve;
