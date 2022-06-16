within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariable
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary"
  extends InjectionTwoWayConstantReturn(
    redeclare BaseClasses.LoadTwoWayValveControl loa,
    redeclare BaseClasses.LoadTwoWayValveControl loa1,
    del2(nPorts=4),
    dp2_nominal=dpPip_nominal + dp2Set,
    m2_flow_nominal=2*mTer_flow_nominal/0.9,
    con(
      typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable,
      typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature));

  parameter Modelica.Units.SI.PressureDifference dp2Set(
    final min=0,
    displayUnit="Pa") = loa1.dpTer_nominal + loa1.dpValve_nominal
    "Secondary pressure differential set point"
    annotation (Dialog(group="Controls"));

  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*m2_flow_nominal,
    final dp_nominal=dp2Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp2SetVal(
    final k=dp2Set) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Controls.PIDWithOperatingMode ctlPum2(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Pump controller"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));


equation
  connect(dp2.port_a, loa1.port_a)
    annotation (Line(points={{100,80},{100,110}}, color={0,127,255}));
  connect(dp2.port_b, loa1.port_b)
    annotation (Line(points={{120,80},{120,110}}, color={0,127,255}));
  connect(resEnd2.port_b, del2.ports[4])
    annotation (Line(points={{140,30},{140,20},{60,20}}, color={0,127,255}));
  connect(dp2SetVal.y, ctlPum2.u_s)
    annotation (Line(points={{-118,30},{-92,30}},color={0,0,127}));
  connect(mode.y[1], ctlPum2.mod)
    annotation (Line(points={{-118,0},{-86,0},{-86,18}}, color={255,127,0}));
  connect(dp2.p_rel, ctlPum2.u_m) annotation (Line(points={{110,71},{110,-8},{
          -80,-8},{-80,18}},
                         color={0,0,127}));
  connect(ctlPum2.y, con.yPum) annotation (Line(points={{-68,30},{6,30},{6,14},
          {18,14}}, color={0,0,127}));
  connect(res2.port_b, resEnd2.port_a)
    annotation (Line(points={{90,60},{140,60},{140,50}}, color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariable.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a two-way valve
that serves as the interface between a variable flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
<li>
No heat is added by the pump to the medium:...
</li>
<li>
Setting of PI for dp set point tracking: reset at max is important,
so is the scaling.
</li>
</ul>
<p>
Fractional load mismatch OK in cooling
</p>
<p>
For this circuit to operate as intended, it is critical that the 
secondary supply temperature set point be different than the primary 
supply temperature.
Otherwise, the tracking error does not change sign and there is no 
overshoot that can desaturate the integral term of the PI controller.
In other words, the controller output is fixed as soon as the measured
value equals the set point.
Threfore, the equilibrium point typically differs from the control
intent which is a primary flow rate varying with the load. 
One can observe that behavior by setting
<code>TLiqSup_nominal=TLiqEnt_nominal</code> and
<code>have_resT2=false</code>.
Such setting yields a fixed valve position with a primary recirculation 
and a flow reversal in the bypass whereas the control intent would 
be a slighlty closer position ensuring a positive flow in the bypass.
Note that this is nearly invisible from an operating standpoint
since the set point and the loads are met.
However, this is definitely detrimental to the overall performance
as the primary circuit is operated at a higher flow rate and lower
&Delta;T than needed.
The system practically behaves as there was no control valve installed
on the primary return line.
This observation holds for both variable and constant consumer circuits, 
although the detrimental effects are much more tangible in the case
of variable consumer circuits.
</p>
</html>"));
end InjectionTwoWayVariable;
