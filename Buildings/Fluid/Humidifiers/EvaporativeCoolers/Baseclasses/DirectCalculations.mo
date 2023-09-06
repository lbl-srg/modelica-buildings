within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block DirectCalculations
  "Calculates the water mass flow rate of a direct evaporative coolder"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Modelica.Units.SI.Area PadArea = 1
  "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Length Depth = 0.5
  "Depth of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Density density = 1.225 "Air density";

  Real Vel "Air velocity";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
  XiOut(redeclare package Medium = Medium)
  "Water vapor mass fraction at the outlet"
    annotation (
      Placement(visible=true, transformation(
        origin={-10,20},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
  XiIn(redeclare package  Medium = Medium)
  "Water vapor mass fraction at the inlet"
  annotation (
      Placement(visible=true, transformation(
        origin={-10,80},
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
        origin={-120,74},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,32},
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
        origin={-120,30},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-118,82},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput eff(final unit="K/K")
  "Evaporative humidifier efficiency"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={110,72},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,70},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TDryBulSupOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the supply air at the outlet"
      annotation (Placement(
      visible=true,
      transformation(
        origin={110,52},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-32},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V_flow(final unit="m3/s")
  "Air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-120,-8},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-18},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput mWat_flowOut(final unit="kg/s")
    "Water mass flow rate at the outlet"
     annotation (Placement(
      visible=true,
      transformation(
        origin={110,2},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-66},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p(final unit="Pa")
  "Pressure"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,-48},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-66},
        extent={{-20,-20},{20,20}},
        rotation=0)));
 Modelica.Blocks.Interfaces.RealOutput dmWat_flow(final unit="kg/s")
 "Water mass flow rate difference between inlet and outlet
  " annotation (Placement(
      visible=true,
      transformation(
        origin={110,-54},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-94},
        extent={{-10,-10},{10,10}},
        rotation=0)));

equation
  Vel =V_flow/PadArea;
  eff = 0.792714 + 0.958569*(Depth) - 0.25193*(Vel) - 1.03215*(Depth^2) +
    0.0262659*(Vel^2) + 0.914869*(Depth*Vel) - 1.48241*(Vel*Depth^2) - 0.018992
    *(Depth*Vel^3) + 1.13137*(Depth^3*Vel) + 0.0327622*(Vel^3*Depth^2) -
    0.145384*(Depth^3*Vel^2);
  TDryBulSupOut =TDryBulSupIn - eff*(TDryBulSupIn - TWetBulSup);
  mWat_flowOut = XiOut.Xi[1]*V_flow*density;
  dmWat_flow = (XiOut.Xi[1] - XiIn.Xi[1])*V_flow*density;
  connect(TDryBulSupIn, XiIn.TDryBul) annotation (Line(points={{-120,74},{-70,74},
          {-70,88},{-21,88}}, color={0,0,127}));
  connect(TWetBulSup, XiIn.TWetBul) annotation (Line(points={{-120,30},{-63,30},
          {-63,80},{-21,80}}, color={0,0,127}));
  connect(p, XiIn.p) annotation (Line(points={{-120,-48},{-90,-48},{-90,-18},{-52,
          -18},{-52,72},{-21,72}}, color={0,0,127}));
  connect(TDryBulSupOut, XiOut.TDryBul) annotation (Line(points={{110,52},{-38,52},
          {-38,28},{-21,28}}, color={0,0,127}));
  connect(TWetBulSup, XiOut.TWetBul) annotation (Line(points={{-120,30},{-64,30},
          {-64,20},{-21,20}}, color={0,0,127}));
  connect(p, XiOut.p) annotation (Line(points={{-120,-48},{-42,-48},{-42,12},{-21,
          12}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Block that calculates the water mass flow rate of the humidifier based on the performance curve.</p>
</html>"));
end DirectCalculations;
