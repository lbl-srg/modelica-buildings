within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block IndirectWetCalculations
  "Calculates the heat transfer in an indirect wet evaporative cooler"

  parameter Real maxEff(
    displayUnit="1")
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    displayUnit="1")
    "Coil flow ratio";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity = "VolumeFlowRate")
    "Primary air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-120,-60},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,-60},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSec_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity = "VolumeFlowRate")
    "Secondary air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-120,-100},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,-100},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulPriIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the air at the inlet"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,100},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,100},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulPriIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the inlet air"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,60},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,60},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulSecIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the air at the inlet"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,20},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,20},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulSecIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the inlet air"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,-20},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-140,-20},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDryBulPriOut(
    displayUnit="degC",
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the outlet air"
    annotation (Placement(
     visible=true,
     transformation(
       origin={120,0},
       extent={{-20,-20},{20,20}},
       rotation=0),
     iconTransformation(
       origin={140,0},
       extent={{-20,-20},{20,20}},
       rotation=0)));

  Real eff(
    displayUnit="1")
    "Actual efficiency of component";

equation
  eff = max((maxEff - floRat*VPri_flow/VSec_flow),0);
  TDryBulPriOut = TDryBulPriIn - eff*(TDryBulSecIn - TWetBulSecIn);

  annotation (defaultComponentName="indWetCal",
  Documentation(info="<html>
  <p>Block that calculates the primary outlet air drybulb temperature of an indirect
  wet evaporative cooler.</p>
</html>", revisions="<html>
<ul>
<li>
Semptember 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(extent={{-120,-120},{120,120}}),
                graphics={              Text(
        extent={{-150,160},{150,120}},
        textString="%name",
        textColor={0,0,255}), Rectangle(extent={{-120,120},{120,-120}},
            lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end IndirectWetCalculations;
