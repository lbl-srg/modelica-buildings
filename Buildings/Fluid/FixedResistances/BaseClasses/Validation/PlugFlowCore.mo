within Buildings.Fluid.FixedResistances.BaseClasses.Validation;
model PlugFlowCore "Simple example of plug flow pipe core"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in pipes"
                                            annotation (
      choicesAllMatching=true);
  parameter Modelica.SIunits.Length dh=0.1
    "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.SIunits.Length dIns = 0.05
    "Thickness of pipe insulation";
  parameter Modelica.SIunits.ThermalConductivity kIns= 0.028
   "Heat conductivity of pipe insulation";

  parameter Modelica.SIunits.SpecificHeatCapacity cPip=500
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";
  parameter Modelica.SIunits.Density rhoPip=8000
    "Density of pipe wall material. 930 for PE, 8000 for steel";

  parameter Real R=1/(kIns*2*Modelica.Constants.pi/
    Modelica.Math.log((dh/2 + dIns)/(dh/2)))
    "Thermal resistance per unit length from fluid to boundary temperature";

  parameter Real C=rho_default*Modelica.Constants.pi*(
      dh/2)^2*cp_default "Thermal capacity per unit length of water in pipe";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

  Modelica.Blocks.Sources.Ramp Tin(
    height=20,
    duration=0,
    offset=273.15 + 50,
    startTime=100) "Ramp temperature signal"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowCore pip(
    redeclare package Medium = Medium,
    from_dp=true,
    dh=0.1,
    length=100,
    m_flow_nominal=1,
    roughness=2.5e-5,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=1,
    R=R,
    C=C,
    v_nominal=1.5,
    T_start_in=323.15,
    T_start_out=323.15) "Pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature bou(T=283.15)
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(bou.port, pip.heatPort)
    annotation (Line(points={{-20,70},{10,70},{10,10}}, color={191,0,0}));
  connect(Tin.y, sou.T_in)
    annotation (Line(points={{-71,4},{-62,4}}, color={0,0,127}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{62,0}}, color={0,127,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/BaseClasses/Validation/PlugFlowCore.mos"
        "Simulate and Plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html>
<p>
Basic test of model
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowCore\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowCore</a>.
This test includes an inlet temperature step under a constant mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2017, by Michael Wetter:<br/>
Corrected wrong hyperlink, updated example for new set of parameters that
are exposed by the pipe model.
</li>
<li>
September 8, 2017 by Bram van der Heijde:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlugFlowCore;
