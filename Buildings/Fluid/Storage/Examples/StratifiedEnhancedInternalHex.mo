within Buildings.Fluid.Storage.Examples;
model StratifiedEnhancedInternalHex
  "Example showing the use of StratifiedEnhancedInternalHex"
  extends Modelica.Icons.Example;

  package MediumTan = Buildings.Media.Water "Medium in the tank";
  package MediumHex = Modelica.Media.Incompressible.Examples.Glycol47
    "Medium in the heat exchanger";

  Buildings.Fluid.Sources.Boundary_pT hotWatOut(
    redeclare package Medium = MediumTan,
    nPorts=1) "Hot water outlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,40})));
  Buildings.Fluid.Sources.MassFlowSource_T solColSup(
    redeclare package Medium = MediumHex,
    nPorts=1,
    m_flow=0.278,
    T=353.15) "Water from solar collector"
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,4})));
  Buildings.Fluid.Sources.Boundary_pT toSolCol(
    redeclare package Medium = MediumHex,
    nPorts=1,
    T=283.15) "Water to solar collector" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-68,-26})));
  Buildings.Fluid.Sources.MassFlowSource_T bouCol(
    redeclare package Medium = MediumTan,
    use_T_in=false,
    nPorts=1,
    m_flow=0.1,
    T=283.15) "Cold water boundary"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = MediumTan,
    m_flow_nominal=0.001,
    VTan=0.151416,
    dIns=0.0762,
    redeclare package MediumHex = MediumHex,
    CHex=40,
    Q_flow_nominal=0.278*4200*20,
    mHex_flow_nominal=0.278,
    hTan=1.746,
    hHex_a=0.995,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial,
    hHex_b=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TTan_nominal=293.15,
    THex_nominal=323.15) "Tank with heat exchanger"
    annotation (Placement(transformation(extent={{-22,-6},{12,26}})));
equation
  connect(solColSup.ports[1], tan.portHex_a) annotation (Line(
      points={{-60,4},{-32,4},{-32,3.92},{-22,3.92}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.portHex_b, toSolCol.ports[1]) annotation (Line(
      points={{-22,-2.8},{-22,-26},{-58,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouCol.ports[1], tan.port_b) annotation (Line(
      points={{40,10},{12,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hotWatOut.ports[1], tan.port_a) annotation (Line(
      points={{-60,40},{-32,40},{-32,10},{-22,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation ( __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/StratifiedEnhancedInternalHex.mos"
        "Simulate and Plot"),
experiment(StopTime=30000.0),
Documentation(info="<html>
<p>
This model provides an example of how the
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a> model can be used.
A constant water draw is taken from the tank while a constant flow of hot water
is passed through the heat exchanger to heat the water in the tank.
<br/>
</p>
</html>",
revisions = "<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
August 29, 2014 by Michael Wetter:<br/>
Revised example to use a different media in the tank and in the
heat exchanger. This is to provide a unit test for
issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>.
</li>
<li>
April 18, 2014 by Michael Wetter:<br/>
Revised example for new connectors and parameters, and provided
more interesting parameter values that cause a tank stratification.
</li>
<li>
Mar 27, 2013 by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end StratifiedEnhancedInternalHex;
