within Buildings.Fluid.HeatPumps.Examples;
model EquationFitWatertoWater "example"

 package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
    per=Data.EquationFitWaterToWater.Trane_Axiom_EXW240(),
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    dp1_nominal=200,
    dp2_nominal=200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Water to Water heatpump"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));

    parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
       "HeatPump performance"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
       "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
       "Nominal mass flow rate";

    Sources.MassFlowSource_T conPum(
    use_m_flow_in=false,
    m_flow=mCon_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
     "Condenser water Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,90})));
    Sources.MassFlowSource_T evaPum(
    m_flow=mEva_flow_nominal,
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = Medium)
     "Evaporator water Pump" annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={73,-47})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TCon_Ent(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
    "Condesner entering water temperature" annotation (Placement(transformation(extent={{-120,74},{-100,94}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEva_ent(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
     "Evaporator entering water temperature" annotation (Placement(transformation(extent={{60,-94},{80,-74}})));
    FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000)
    "Flow resistance" annotation (Placement(transformation(extent={{58,56},{78,76}})));
    FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
     m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)
    "Flow resistance" annotation (Placement(transformation(extent={{-10,-94},{10,-74}})));
    Sources.FixedBoundary heaVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for heating load"  annotation (Placement(transformation(extent={{104,74},{84,94}})));
    Sources.FixedBoundary cooVol(nPorts=1, redeclare package Medium = Medium)
    "Volume for cooling load" annotation (Placement(transformation(extent={{-60,-94},{-40,-74}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TSetCoo(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature" annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TSetHea(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=40 + 273.15,
    startTime=0)
     "Condenser setpoint water temperature" annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
    height=10,
    duration(displayUnit="h") = 14400,
    offset=-5,
    startTime=0)
    "HeatPump operational mode input signal" annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
    Controls.OBC.CDL.Continuous.LessEqualThreshold          lesEquThr(threshold=-1)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Controls.OBC.CDL.Continuous.GreaterEqualThreshold       greEquThr(threshold=1)
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt(integerTrue=-1)
      annotation (Placement(transformation(extent={{-48,20},{-28,40}})));
    Controls.OBC.CDL.Conversions.BooleanToInteger           booToInt1
      annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
    Controls.OBC.CDL.Integers.Add                           addInt
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

equation
  connect(heaPum.port_a1, conPum.ports[1])
    annotation (Line(points={{32,6},{24,
          6},{24,90},{-40,90}}, color={0,127,255}));
  connect(TCon_Ent.y, conPum.T_in)
    annotation (Line(points={{-99,84},{-80,84},{-80,
          86},{-62,86}},           color={0,0,127}));
  connect(TEva_ent.y, evaPum.T_in)
    annotation (Line(points={{81,-84},{98,-84},{
          98,-51.4},{86.2,-51.4}}, color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
    annotation (Line(points={{62,-47},{
          56,-47},{56,-6},{52,-6}}, color={0,127,255}));
  connect(cooVol.ports[1], res2.port_a)
    annotation (Line(points={{-40,-84},{-10,-84}}, color={0,127,255}));
  connect(res1.port_a, heaPum.port_b1)
    annotation (Line(points={{58,66},{52,66},{52,6}},  color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
    annotation (Line(points={{10,-84},{24,-84},{24,-6},{32,-6}},  color={0,127,255}));
  connect(TSetHea.y, heaPum.TConSet)
    annotation (Line(points={{1,70},{16,70},{16,9},{30.6,9}},
                                                            color={0,0,127}));
  connect(TSetCoo.y, heaPum.TEvaSet)
    annotation (Line(points={{1,-50},{16,-50},{
          16,-9},{30.6,-9}},color={0,0,127}));
  connect(uMod.y, greEquThr.u)
    annotation (Line(points={{-99,0},{-96,0},{-96,
          -30},{-82,-30}}, color={0,0,127}));
  connect(lesEquThr.y,booToInt. u)
    annotation (Line(points={{-59,30},{-50,30}},color={255,0,255}));
  connect(greEquThr.y,booToInt1. u)
    annotation (Line(points={{-59,-30},{-50,-30}},        color={255,0,255}));
  connect(booToInt1.y,addInt. u2)
    annotation (Line(points={{-27,-30},{-18,-30},
          {-18,-6},{-10,-6}},
                           color={255,127,0}));
  connect(addInt.y, heaPum.uMod)
    annotation (Line(points={{13,0},{20,0},{20,1.66533e-16},{30.6,1.66533e-16}},
                                             color={255,127,0}));
  connect(res1.port_b, heaVol.ports[1])
    annotation (Line(points={{78,66},{84,66},{84,84}}, color={0,127,255}));
  connect(uMod.y, lesEquThr.u)
    annotation (Line(points={{-99,0},{-96,0},{-96,30},
          {-82,30}}, color={0,0,127}));
  connect(booToInt.y, addInt.u1)
    annotation (Line(points={{-27,30},{-18,30},{
          -18,6},{-10,6}}, color={255,127,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{140,100}})),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/EquationFitWaterToWater.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
     Documentation(info="<html>
<p>
Example that simulates the performance of <a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.EquationFitWaterToWater </a> based on the equation fit method.
The heat pump takes as an input the condenser or the evaporator leaving water temperature and an integer input to
specify the heat pump operational mode.


</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end EquationFitWatertoWater;
