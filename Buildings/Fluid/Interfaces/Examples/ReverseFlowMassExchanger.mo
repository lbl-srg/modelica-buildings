within Buildings.Fluid.Interfaces.Examples;
model ReverseFlowMassExchanger
  "Model that tests the reverse flow for a mass exchanger"
  extends Modelica.Icons.Example;
package Medium = Buildings.Media.Air;
  Modelica.Blocks.Math.Add cheTem(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Modelica.Blocks.Math.Add cheEnt(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  Modelica.Blocks.Math.Add cheMas(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Modelica.Fluid.Sources.MassFlowSource_T source2(
    m_flow=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    nPorts=1,
    T(displayUnit="degC") = 303.15,
    X={0.02,0.98})  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={38,70})));
  Buildings.Fluid.MassExchangers.ConstantEffectiveness masExcFor(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    dp1_nominal=0,
    dp2_nominal=0,
    epsL=0) "Mass exchanger with forward flow"
    annotation (Placement(transformation(extent={{-50,84},{-30,104}})));
  Buildings.Fluid.MassExchangers.ConstantEffectiveness masExcRev(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    dp1_nominal=0,
    dp2_nominal=0,
    epsL=0) "Mass exchanger with reverse flow"
    annotation (Placement(transformation(extent={{-30,30},{-50,50}})));
  Buildings.Fluid.Sources.Boundary_pT sink2(
     redeclare package Medium = Medium,
     nPorts=2) "Fluid sink"
     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-152,30})));
  FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-88,78},{-108,98}})));
  FixedResistances.PressureDrop res4(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-88,24},{-108,44}})));
  Sensors.SpecificEnthalpy senEnt3(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-310,140},{-290,160}})));
  Buildings.Fluid.Sensors.Temperature senTem3(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-350,140},{-330,160}})));
  Sensors.MassFraction senMas3(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-270,140},{-250,160}})));
  Sensors.SpecificEnthalpy senEnt4(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-310,60},{-290,80}})));
  Buildings.Fluid.Sensors.Temperature senTem4(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-350,60},{-330,80}})));
  Sensors.MassFraction senMas4(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-270,60},{-250,80}})));
  Modelica.Blocks.Math.Add cheTem1(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Modelica.Blocks.Math.Add cheEnt1(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Modelica.Blocks.Math.Add cheMas1(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Modelica.Fluid.Sources.MassFlowSource_T source3(
    m_flow=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    X={0.01,0.99},
    nPorts=1,
    T(displayUnit="degC") = 293.15)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-150,70})));
  Modelica.Fluid.Sources.MassFlowSource_T source4(
    m_flow=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    nPorts=1,
    T(displayUnit="degC") = 303.15,
    X={0.02,0.98})  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={38,30})));

  Modelica.Fluid.Sources.MassFlowSource_T source1(
    m_flow=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    X={0.01,0.99},
    nPorts=1,
    T(displayUnit="degC") = 293.15)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-150,100})));
  Sources.Boundary_pT sink1(
    redeclare package Medium = Medium,
    nPorts=2) "Fluid sink"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={40,98})));
  Sensors.SpecificEnthalpy senEnt1(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{10,140},{30,160}})));
  Buildings.Fluid.Sensors.Temperature senTem1(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{-30,140},{-10,160}})));
  Sensors.MassFraction senMas1(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{50,140},{70,160}})));
  Buildings.Fluid.Sensors.Temperature senTem2(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Sensors.SpecificEnthalpy senEnt2(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Sensors.MassFraction senMas2(redeclare package Medium = Medium,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-12,36},{8,56}})));

equation
  connect(res1.port_b, sink1.ports[1]) annotation (Line(
      points={{10,100},{30,100}},
      color={0,127,255}));
  connect(res2.port_b, sink1.ports[2]) annotation (Line(
      points={{8,46},{16,46},{16,96},{30,96}},
      color={0,127,255}));
  connect(senTem1.T,cheTem. u1) annotation (Line(
      points={{-13,150},{0,150},{0,126},{70,126},{70,16},{158,16}},
      color={0,0,127}));
  connect(senEnt1.h_out,cheEnt. u1) annotation (Line(
      points={{31,150},{34,150},{34,124},{146,124},{146,-14},{158,-14}},
      color={0,0,127}));
  connect(senMas1.X,cheMas. u1) annotation (Line(
      points={{71,150},{140,150},{140,-44},{158,-44}},
      color={0,0,127}));
  connect(senTem2.T,cheTem. u2) annotation (Line(
      points={{37,-50},{48,-50},{48,4},{158,4}},
      color={0,0,127}));
  connect(senEnt2.h_out,cheEnt. u2) annotation (Line(
      points={{81,-50},{88,-50},{88,-26},{158,-26}},
      color={0,0,127}));
  connect(senMas2.X,cheMas. u2) annotation (Line(
      points={{121,-50},{140,-50},{140,-56},{158,-56}},
      color={0,0,127}));
  connect(masExcFor.port_b1, res1.port_a) annotation (Line(
      points={{-30,100},{-10,100}},
      color={0,127,255}));
  connect(masExcFor.port_a1, source1.ports[1]) annotation (Line(
      points={{-50,100},{-140,100}},
      color={0,127,255}));
  connect(masExcRev.port_a1, res2.port_a) annotation (Line(
      points={{-30,46},{-12,46}},
      color={0,127,255}));
  connect(source2.ports[1], masExcFor.port_a2) annotation (Line(
      points={{28,70},{20,70},{20,88},{-30,88}},
      color={0,127,255}));
  connect(masExcRev.port_a1, senTem2.port) annotation (Line(
      points={{-30,46},{-20,46},{-20,-70},{30,-70},{30,-60}},
      color={0,127,255}));
  connect(masExcRev.port_a1, senEnt2.port) annotation (Line(
      points={{-30,46},{-20,46},{-20,-70},{70,-70},{70,-60}},
      color={0,127,255}));
  connect(masExcRev.port_a1, senMas2.port) annotation (Line(
      points={{-30,46},{-20,46},{-20,-70},{110,-70},{110,-60}},
      color={0,127,255}));
  connect(masExcFor.port_b1, senTem1.port) annotation (Line(
      points={{-30,100},{-20,100},{-20,140}},
      color={0,127,255}));
  connect(masExcFor.port_b1, senEnt1.port) annotation (Line(
      points={{-30,100},{-20,100},{-20,132},{20,132},{20,140}},
      color={0,127,255}));
  connect(masExcFor.port_b1, senMas1.port) annotation (Line(
      points={{-30,100},{-20,100},{-20,132},{60,132},{60,140}},
      color={0,127,255}));
  connect(masExcFor.port_b2, res3.port_a) annotation (Line(
      points={{-50,88},{-88,88}},
      color={0,127,255}));
  connect(masExcRev.port_a2, res4.port_a) annotation (Line(
      points={{-50,34},{-88,34}},
      color={0,127,255}));
  connect(res3.port_b, sink2.ports[1]) annotation (Line(
      points={{-108,88},{-128,88},{-128,28},{-142,28}},
      color={0,127,255}));
  connect(res4.port_b, sink2.ports[2]) annotation (Line(
      points={{-108,34},{-126,34},{-126,32},{-142,32}},
      color={0,127,255}));
  connect(senTem3.T,cheTem1. u1) annotation (Line(
      points={{-333,150},{-312,150},{-312,-4},{-202,-4}},
      color={0,0,127}));
  connect(senTem4.T,cheTem1. u2) annotation (Line(
      points={{-333,70},{-320,70},{-320,-16},{-202,-16}},
      color={0,0,127}));
  connect(senEnt3.h_out,cheEnt1. u1) annotation (Line(
      points={{-289,150},{-272,150},{-272,-34},{-202,-34}},
      color={0,0,127}));
  connect(senEnt4.h_out,cheEnt1. u2) annotation (Line(
      points={{-289,70},{-280,70},{-280,-46},{-202,-46}},
      color={0,0,127}));
  connect(senMas3.X,cheMas1. u1) annotation (Line(
      points={{-249,150},{-230,150},{-230,-64},{-202,-64}},
      color={0,0,127}));
  connect(senMas4.X,cheMas1. u2) annotation (Line(
      points={{-249,70},{-240,70},{-240,-76},{-202,-76}},
      color={0,0,127}));
  connect(masExcFor.port_b2, senTem3.port) annotation (Line(
      points={{-50,88},{-70,88},{-70,128},{-340,128},{-340,140}},
      color={0,127,255}));
  connect(masExcFor.port_b2, senEnt3.port) annotation (Line(
      points={{-50,88},{-70,88},{-70,128},{-300,128},{-300,140}},
      color={0,127,255}));
  connect(masExcFor.port_b2, senMas3.port) annotation (Line(
      points={{-50,88},{-70,88},{-70,128},{-260,128},{-260,140}},
      color={0,127,255}));
  connect(masExcRev.port_a2, senTem4.port) annotation (Line(
      points={{-50,34},{-70,34},{-70,50},{-340,50},{-340,60}},
      color={0,127,255}));
  connect(masExcRev.port_a2, senEnt4.port) annotation (Line(
      points={{-50,34},{-70,34},{-70,50},{-300,50},{-300,60}},
      color={0,127,255}));
  connect(masExcRev.port_a2, senMas4.port) annotation (Line(
      points={{-50,34},{-70,34},{-70,50},{-260,50},{-260,60}},
      color={0,127,255}));
  connect(source3.ports[1], masExcRev.port_b1) annotation (Line(
      points={{-140,70},{-120,70},{-120,46},{-50,46}},
      color={0,127,255}));
  connect(source4.ports[1], masExcRev.port_b2) annotation (Line(
      points={{28,30},{0,30},{0,34},{-30,34}},
      color={0,127,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ReverseFlowMassExchanger.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-400,-200},{200,
            200}})),
    Documentation(info="<html>
<p>
This model tests whether the results for a mass exchanger are
identical for forward flow and reverse flow.
</p>
<p>
Note that if the latent heat transfer effectiveness is non-zero, then
the results will differ. The reason is that the maximum capacity stream
is computed using the mass flow rates at <code>port_a1</code>
and <code>port_a2</code>. For reverse flow, they are not equal if
moisture is added to the mass flow rate. Using an average mass flow rate
in computing the heat and moisture transfer would lead to identical results,
but it would introduce additional nonlinear equations that need to be solved.
Therefore, the model uses the mass flow rates at <code>port_a1</code>
and <code>port_a2</code>.
</p>
<p>
<b>Note:</b> This problem fails to translate in Dymola 2012 due to an error in Dymola's support
of stream connector. This bug will be corrected in future versions of Dymola.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2020, by Michael Wetter:<br/>
Updated model to use one port temperature sensor from Modelica Standard Library.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1399\"> #1399</a>.
</li>
<li>
May 2, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 2, 2016, by Michael Wetter:<br/>
Changed assertions to blocks that compute the difference,
and added the difference to the regression results.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
October 9, 2013, by Michael Wetter:<br/>
Replaced
<code>Modelica.Fluid.Sources.FixedBoundary</code>
with
<code>Buildings.Fluid.Sources.FixedBoundary</code>
as otherwise, the pedantic model check fails in
Dymola 2014 FD01 beta3.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReverseFlowMassExchanger;
