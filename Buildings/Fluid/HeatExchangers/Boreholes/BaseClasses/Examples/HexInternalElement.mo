within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.Examples;
model HexInternalElement
  "Model that tests the basic element that is used to built borehole models"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid";

  Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement hex(
    redeclare package Medium = Medium,
    m1_flow_nominal=0.3,
    m2_flow_nominal=0.3,
    rTub=0.02,
    kTub=0.5,
    rBor=0.1,
    xC=0.025,
    kSoi=3.1,
    dp1_nominal=5,
    dp2_nominal=5,
    hSeg=20,
    redeclare parameter Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite matFil,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TFil_start=283.15)
             annotation (Placement(transformation(extent={{10,-16},{30,4}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    p=101340,
    T=303.15) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=false,
    use_T_in=false,
    p=101330,
    T=283.15) annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,6.66134e-16},{-16,6.66134e-16},{-16,1.22125e-15},{10,
          1.22125e-15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, hex.port_a2) annotation (Line(
      points={{30,1.22125e-15},{54,1.22125e-15},{54,-12},{30,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, sin_2.ports[1]) annotation (Line(
      points={{10,-12},{-16,-12},{-16,-30},{-40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/HexInternalElement.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example illustrates modeling the internal part of a borehole heat exchanger.
The borehole is constitued with two pipes that are symetricaly spaced in the borehole.
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Added declaration of soil properties as this is needed for the new
U-tube model.
</li>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end HexInternalElement;
