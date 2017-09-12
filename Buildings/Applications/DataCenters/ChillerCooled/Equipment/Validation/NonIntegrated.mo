within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model NonIntegrated "Non-integrated WSE  in a chilled water system"

  extends Modelica.Icons.Example;
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses.PartialPlant(
    sou1(nPorts=1),
    sin1(nPorts=1),
    TSet(k=273.15 + 5.56),
    TEva_in(k=273.15 + 15.28));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated nonIntWSE(
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Non-integrated waterside economizer "
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Modelica.Blocks.Sources.BooleanStep onChi(
    startTime = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(
    startValue=true,
    startTime( displayUnit="h") = 7200)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumCHW,
    m_flow=mCHW_flow_nominal,
    nPorts=1,
    use_T_in=true) "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-70})));
equation
  connect(onChi.y, nonIntWSE.on[1])
    annotation (Line(points={{-69,80},{-69,80},{-24,80},{-24,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(onWSE.y, nonIntWSE.on[2])
    annotation (Line(points={{-39,60},{-24,60},{-24,60},{-24,-30.4},{-11.6,
          -30.4}},                             color={255,0,255}));
  connect(TSet.y, nonIntWSE.TSet)
    annotation (Line(points={{-69,30},{-48,30},{-20,30},{-20,-27.2},{-11.6,-27.2}},
                                          color={0,0,127}));
  connect(nonIntWSE.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,-32},
          {-22,-32},{-28,-32},{-28,-4},{-40,-4}}, color={0,127,255}));
  connect(nonIntWSE.port_b2, TSup.port_a)
    annotation (Line(points={{-10,-44},{-20,
          -44},{-40,-44}}, color={0,127,255}));
  connect(nonIntWSE.port_b1, sin1.ports[1])
    annotation (Line(points={{10,-32},{26,-32},{26,-4},{70,-4}},
                                    color={0,127,255}));
  connect(nonIntWSE.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-44},{20,-44},{26,-44},{26,-70},{40,-70}},
                                               color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{69,-70},{68,-70},{68,-66},{66,-66},{66,-66},{62,
          -66},{62,-66}},                                   color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/NonIntegrated.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates how the model responses
according to different cooling mode signals
(free cooling mode, and fully mechanical cooling).
</p>
</html>", revisions="<html>
<ul>
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
      Tolerance=1e-06));
end NonIntegrated;
