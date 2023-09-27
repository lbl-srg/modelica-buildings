within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block DirectCalculations
  "Calculates the water vapor mass flow rate of a direct evaporative coolder"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  Real eff(
    final unit="1")
    "Evaporative humidifier efficiency";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity = "VolumeFlowRate")
    "Air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-120,-20},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-20},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the air at the inlet"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,60},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,20},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the inlet air"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,20},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,60},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput p(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="AbsolutePressure")
    "Pressure"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,-60},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-60},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(
     visible=true,
     transformation(
       origin={120,0},
       extent={{-20,-20},{20,20}},
       rotation=0),
     iconTransformation(
       origin={120,0},
       extent={{-20,-20},{20,20}},
       rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
    XiOut(redeclare package Medium = Medium)
    "Water vapor mass fraction at the outlet";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
    XiIn(redeclare package Medium =  Medium)
    "Water vapor mass fraction at the inlet";

  Modelica.Units.SI.Velocity vel
    "Air velocity";

  Modelica.Units.SI.ThermodynamicTemperature TDryBulOut(
    displayUnit="degC")
    "Dry bulb temperature of the outlet air";

  Modelica.Units.SI.MassFlowRate mWat_flowOut
    "Water mass flow rate at the outlet";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default, p=Medium.p_default, X=Medium.X_default)
    "Default state of medium";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

equation
  vel =V_flow/padAre;
  eff = 0.792714 + 0.958569*(dep) - 0.25193*(vel) - 1.03215*(dep^2) +
    0.0262659*(vel^2) + 0.914869*(dep*vel) - 1.48241*(vel*dep^2) - 0.018992
    *(dep*vel^3) + 1.13137*(dep^3*vel) + 0.0327622*(vel^3*dep^2) -
    0.145384*(dep^3*vel^2);
  TDryBulOut = TDryBulIn - eff*(TDryBulIn - TWetBulIn);
  mWat_flowOut = XiOut.Xi[1]*V_flow*rho_default;
  dmWat_flow = (XiOut.Xi[1] - XiIn.Xi[1])*V_flow*rho_default;
  TDryBulIn = XiIn.TDryBul;
  TWetBulIn = XiIn.TWetBul;
  p = XiIn.p;
  TDryBulOut = XiOut.TDryBul;
  TWetBulIn = XiOut.TWetBul;
  p = XiOut.p;
  annotation (Documentation(info="<html>
<p>Block that calculates the water vapor mass flow rate of the humidifier based on the performance curve.</p>
</html>", revisions="<html>
<ul>
<li>
Semptember 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={              Text(
        extent={{-152,144},{148,104}},
        textString="%name",
        textColor={0,0,255}), Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end DirectCalculations;
