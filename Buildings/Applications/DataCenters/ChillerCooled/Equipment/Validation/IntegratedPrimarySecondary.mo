within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model IntegratedPrimarySecondary
  "Integrated WSE on the load side in a primary-secondary chilled water system"
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=2),
    sin1(nPorts=2),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 10.28),
    sin2(nPorts=2));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary
    intWSEPriSec1(
    m1_flow_chi_nominal=mCW_flow_nominal,
    m2_flow_chi_nominal=mCHW_flow_nominal,
    m1_flow_wse_nominal=mCW_flow_nominal,
    m2_flow_wse_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dp1_chi_nominal=dpCW_nominal,
    dp1_wse_nominal=dpCW_nominal,
    dp2_chi_nominal=dpCHW_nominal,
    dp2_wse_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    numChi=numChi,
    addPowerToMedium=false,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Integrated waterside economizer on the load side of a primary-secondary chilled water system"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if onChi.y and not onWSE.y then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,80},{20,100}})));
  Modelica.Blocks.Sources.RealExpression yPum(y=if onChi.y then 1 else 0)
    "Input signal for primary pump"
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = MediumCHW,
    p=MediumCHW.p_default + 30E3,
    nPorts=2,
    use_T_in=true) "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-74})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary
    intWSEPriSec2(
    m1_flow_chi_nominal=mCW_flow_nominal,
    m2_flow_chi_nominal=mCHW_flow_nominal,
    m1_flow_wse_nominal=mCW_flow_nominal,
    m2_flow_wse_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dp1_chi_nominal=dpCW_nominal,
    dp1_wse_nominal=dpCW_nominal,
    dp2_chi_nominal=dpCHW_nominal,
    dp2_wse_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    numChi=numChi,
    addPowerToMedium=false,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Integrated waterside economizer on the load side of a primary-secondary chilled water system"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  Modelica.Blocks.Sources.BooleanPulse tri(period=1800)
    "Trigger controller reset"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPum(each pressure=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
        V_flow=mCHW_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpCHW_nominal*{1.2,1.1,
        1.0,0.6})) "Pump performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup2(redeclare package Medium =
        MediumCHW, m_flow_nominal=mCHW_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-126},{-60,-106}})));
equation
  connect(TSet.y, intWSEPriSec1.TSet) annotation (Line(points={{-79,30},{-16,30},
          {-16,-27.2},{-11.6,-27.2}}, color={0,0,127}));
  connect(yVal5.y, intWSEPriSec1.yVal5) annotation (Line(points={{19,90},{-20,90},
          {-20,-35},{-11.6,-35}}, color={0,0,127}));
  connect(intWSEPriSec1.port_a1, sou1.ports[1]) annotation (Line(points={{-10,-32},
          {-22,-32},{-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(intWSEPriSec1.port_b2, TSup1.port_a) annotation (Line(points={{-10,-44},
          {-20,-44},{-40,-44}}, color={0,127,255}));
  connect(intWSEPriSec1.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},
          {20,-32},{20,-4},{70,-4}}, color={0,127,255}));
  connect(intWSEPriSec1.port_a2, sou2.ports[1]) annotation (Line(points={{10,-44},
          {26,-44},{26,-72},{40,-72}},          color={0,127,255}));
  connect(yPum.y, intWSEPriSec1.yPum[1]) annotation (Line(points={{19,70},{-22,
          70},{-22,-41.5},{-11.5,-41.5}},
                                  color={0,0,127}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{62,-70}},          color={0,0,127}));
  connect(onChi.y, intWSEPriSec1.on[1]) annotation (Line(points={{-79,90},{-18,90},
          {-18,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(onWSE.y, intWSEPriSec1.on[2]) annotation (Line(points={{-79,60},{-18,60},
          {-18,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(TSet.y, intWSEPriSec2.TSet) annotation (Line(points={{-79,30},{-16,30},
          {-16,-99.2},{-11.6,-99.2}}, color={0,0,127}));
  connect(onChi.y, intWSEPriSec2.on[1]) annotation (Line(points={{-79,90},{-18,90},
          {-18,-102.4},{-11.6,-102.4}}, color={255,0,255}));
  connect(onWSE.y, intWSEPriSec2.on[2]) annotation (Line(points={{-79,60},{-18,60},
          {-18,-102.4},{-11.6,-102.4}}, color={255,0,255}));
  connect(yVal5.y, intWSEPriSec2.yVal5) annotation (Line(points={{19,90},{-20,90},
          {-20,-107},{-11.6,-107}}, color={0,0,127}));
  connect(yPum.y, intWSEPriSec2.yPum[1]) annotation (Line(points={{19,70},{-22,
          70},{-22,-113.5},{-11.5,-113.5}},
                                    color={0,0,127}));
  connect(sou1.ports[2], intWSEPriSec2.port_a1) annotation (Line(points={{-40,-4},
          {-28,-4},{-28,-104},{-10,-104}}, color={0,127,255}));
  connect(sou2.ports[2], intWSEPriSec2.port_a2) annotation (Line(points={{40,-76},
          {26,-76},{26,-116},{10,-116}}, color={0,127,255}));
  connect(intWSEPriSec2.port_b1, sin1.ports[2]) annotation (Line(points={{10,-104},
          {20,-104},{20,-4},{70,-4}}, color={0,127,255}));
  connect(tri.y, intWSEPriSec2.trigger) annotation (Line(points={{-79,-150},{-6,
          -150},{-6,-120}}, color={255,0,255}));
  connect(sin2.ports[2], TSup2.port_b) annotation (Line(points={{-70,-70},{-64,-70},
          {-64,-116},{-60,-116}}, color={0,127,255}));
  connect(TSup2.port_a, intWSEPriSec2.port_b2)
    annotation (Line(points={{-40,-116},{-10,-116}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/IntegratedPrimarySecondary.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates how the model responses
according to different cooling mode signals
(free cooling mode, partially mechanical cooling and fully mechanical cooling).
</p>
<p>
The reponses are also compared with a second case where the PI controller in the WSE
is reset every 1800s.
</p>
</html>", revisions="<html>
<ul>
<li>
May 13, 2021, by Michael Wetter:<br/>
Changed boundary condition model to prescribed pressure rather than prescribed mass flow rate.
Prescribing the mass flow rate caused
unreasonably large pressure drop because the mass flow rate was forced through a closed valve.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2488\">#2488</a>.
</li>
<li>
January 28, 2019, by Yangyang Fu:<br/>
Added test case for PI controller reset.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
September 11, 2017, by Michael Wetter:<br/>
Corrected wrong use of replaceable model in the base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>.
</li>
<li>
July 22, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=21600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-160},{100,100}})));
end IntegratedPrimarySecondary;
