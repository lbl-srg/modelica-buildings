within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block DirectCalculations
  "Calculates the water mass flow rate of a direct evaporative coolder"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Modelica.Units.SI.Area padAre = 1
  "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Length dep = 0.5
  "Depth of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Density den = 1.225 "Air density";

  Real Vel "Air velocity";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
  XiOut(redeclare package Medium = Medium)
  "Water vapor mass fraction at the outlet"
    annotation (
      Placement(visible=true, transformation(
        origin={0,-30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
  XiIn(redeclare package  Medium = Medium)
  "Water vapor mass fraction at the inlet"
  annotation (
      Placement(visible=true, transformation(
        origin={0,50},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput TDryBulSupIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the supply air at the inlet"
      annotation (Placement(
      visible=true,
      transformation(
        origin={-111,59},
        extent={{-11,-11},{11,11}},
        rotation=0),
      iconTransformation(
        origin={-120,30},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput TWetBulSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the supply air"
      annotation (Placement(
      visible=true,
      transformation(
        origin={-111,21},
        extent={{-11,-11},{11,11}},
        rotation=0),
      iconTransformation(
        origin={-120,80},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput eff(final unit="K/K")
  "Evaporative humidifier efficiency"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={120,80},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={120,80},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TDryBulSupOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the supply air at the outlet"
      annotation (Placement(
      visible=true,
      transformation(
        origin={110,20},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={120,28},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V_flow(final unit="m3/s")
  "Air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-111,-21},
        extent={{-11,-11},{11,11}},
        rotation=0),
      iconTransformation(
        origin={-120,-30},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput mWat_flowOut(final unit="kg/s")
    "Water mass flow rate at the outlet"
     annotation (Placement(
      visible=true,
      transformation(
        origin={110,-20},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={120,-30},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p(final unit="Pa")
  "Pressure"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-111,-61},
        extent={{-11,-11},{11,11}},
        rotation=0),
      iconTransformation(
        origin={-120,-80},
        extent={{-20,-20},{20,20}},
        rotation=0)));
 Modelica.Blocks.Interfaces.RealOutput dmWat_flow(final unit="kg/s")
 "Water mass flow rate difference between inlet and outlet
  " annotation (Placement(
      visible=true,
      transformation(
        origin={110,-60},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={120,-80},
        extent={{-20,-20},{20,20}},
        rotation=0)));

equation
  Vel =V_flow/padAre;
  eff = 0.792714 + 0.958569*(dep) - 0.25193*(Vel) - 1.03215*(dep^2) +
    0.0262659*(Vel^2) + 0.914869*(dep*Vel) - 1.48241*(Vel*dep^2) - 0.018992
    *(dep*Vel^3) + 1.13137*(dep^3*Vel) + 0.0327622*(Vel^3*dep^2) -
    0.145384*(dep^3*Vel^2);
  TDryBulSupOut =TDryBulSupIn - eff*(TDryBulSupIn - TWetBulSup);
  mWat_flowOut = XiOut.Xi[1]*V_flow*den;
  dmWat_flow = (XiOut.Xi[1] - XiIn.Xi[1])*V_flow*den;
  connect(TDryBulSupIn, XiIn.TDryBul) annotation (Line(points={{-111,59},{-70,59},
          {-70,58},{-11,58}}, color={0,0,127}));
  connect(TWetBulSup, XiIn.TWetBul) annotation (Line(points={{-111,21},{-63,21},
          {-63,50},{-11,50}}, color={0,0,127}));
  connect(p, XiIn.p) annotation (Line(points={{-111,-61},{-90,-61},{-90,-18},{-52,
          -18},{-52,42},{-11,42}}, color={0,0,127}));
  connect(TDryBulSupOut, XiOut.TDryBul) annotation (Line(points={{110,20},{-38,20},
          {-38,-22},{-11,-22}},
                              color={0,0,127}));
  connect(TWetBulSup, XiOut.TWetBul) annotation (Line(points={{-111,21},{-64,21},
          {-64,-30},{-11,-30}},
                              color={0,0,127}));
  connect(p, XiOut.p) annotation (Line(points={{-111,-61},{-42,-61},{-42,-38},{-11,
          -38}},color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Block that calculates the water mass flow rate of the humidifier based on the performance curve.</p>
</html>"), Icon(graphics={              Text(
        extent={{-152,144},{148,104}},
        textString="%name",
        textColor={0,0,255}), Rectangle(extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end DirectCalculations;
