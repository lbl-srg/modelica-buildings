within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Validation;
model IndirectWetCalculations
  "Validation of the IndirectWetCalculations block"
  extends Modelica.Icons.Example;

  parameter Real maxEff(
    displayUnit="1") = 0.8
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    displayUnit="1") = 0.16
    "Coil flow ratio";

  parameter Modelica.Units.SI.ThermodynamicTemperature TDryBulSup_nominal = 296.15
    "Nominal supply air drybulb temperature";

  parameter Modelica.Units.SI.ThermodynamicTemperature TWetBulSup_nominal = 289.3
    "Nominal supply air wetbulb temperature";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = 1
    "Nominal supply air volume flowrate";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations
    indWetCal(maxEff=maxEff, floRat=floRat)
    annotation (Placement(visible=true, transformation(
      origin={50,50},
      extent={{-12,-12},{12,12}},
      rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations
    indWetCal1(maxEff=maxEff, floRat=floRat)
    annotation (
      Placement(visible=true, transformation(
        origin={50,0},
        extent={{-12,-12},{12,12}},
        rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations
    indWetCal2(maxEff=maxEff, floRat=floRat)
    annotation (Placement(visible=true, transformation(
      origin={50,-50},
      extent={{-12,-12},{12,12}},
      rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations
    indWetCal3(maxEff=maxEff, floRat=floRat)
    annotation (Placement(visible=true, transformation(
      origin={50,-90},
      extent={{-12,-12},{12,12}},
      rotation=0)));

protected
  Modelica.Blocks.Sources.Constant TWetBulSupCon(k=TWetBulSup_nominal)
    "Constant wet bulb temperature signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Constant TDryBulSupCon(k=TDryBulSup_nominal)
    "Constant drybulb temperature signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Ramp TWetBulSupRam(
    duration=60,
    height=5,
    offset=TWetBulSup_nominal,
    startTime=0) "Ramp signal for wet-bulb temperature" annotation (Placement(
        visible=true, transformation(
        origin={-80,-50},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Ramp TDryBulSupRam(
    duration=60,
    height=15,
    offset=TDryBulSup_nominal,
    startTime=0) "Ramp signal for drybulb temperature" annotation (Placement(
        visible=true, transformation(
        origin={-80,-100},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Constant V_flowCon(k=V_flow_nominal)
    "Constant volume flowrate signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Ramp V_flowRam(
    duration=60,
    height=0.5,
    offset=V_flow_nominal,
    startTime=0) "Ramp signal for volume flowrate" annotation (Placement(
        visible=true, transformation(
        origin={-10,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));

equation
  connect(TDryBulSupCon.y, indWetCal.TDryBulPriIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,60},{36,60}},                    color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal.TDryBulSecIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,52},{36,52}},                    color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal.TWetBulPriIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,56},{36,56}},          color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal.TWetBulSecIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,48},{36,48}},                    color={0,0,127}));
  connect(V_flowRam.y, indWetCal.VPri_flow) annotation (Line(points={{1,80},{20,
          80},{20,44},{36,44}},      color={0,0,127}));
  connect(V_flowCon.y, indWetCal.VSec_flow) annotation (Line(points={{-69,-10},{
          -40,-10},{-40,40},{36,40}},                color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal1.TDryBulPriIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,10},{36,10}},                    color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal1.TDryBulSecIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,2},{36,2}},                      color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal1.TWetBulPriIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,6},{36,6}},                      color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal1.TWetBulSecIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,-2},{36,-2}},   color={0,0,127}));
  connect(V_flowRam.y, indWetCal1.VSec_flow) annotation (Line(points={{1,80},{20,
          80},{20,-10},{36,-10}},
                                color={0,0,127}));
  connect(V_flowCon.y, indWetCal1.VPri_flow) annotation (Line(points={{-69,-10},
          {-40,-10},{-40,-6},{36,-6}}, color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal2.TDryBulPriIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,-40},{36,-40}},     color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal2.TWetBulPriIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,-44},{36,-44}},     color={0,0,127}));
  connect(TDryBulSupRam.y, indWetCal2.TDryBulSecIn) annotation (Line(points={{-69,
          -100},{-30,-100},{-30,-48},{36,-48}}, color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal2.TWetBulSecIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,-52},{36,-52}},     color={0,0,127}));
  connect(V_flowCon.y, indWetCal2.VPri_flow) annotation (Line(points={{-69,-10},
          {-40,-10},{-40,-56},{36,-56}}, color={0,0,127}));
  connect(V_flowCon.y, indWetCal2.VSec_flow) annotation (Line(points={{-69,-10},
          {-40,-10},{-40,-60},{36,-60}}, color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal3.TDryBulPriIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,-80},{36,-80}},     color={0,0,127}));
  connect(TDryBulSupCon.y, indWetCal3.TDryBulSecIn) annotation (Line(points={{-69,30},
          {-60,30},{-60,-88},{36,-88}},     color={0,0,127}));
  connect(TWetBulSupCon.y, indWetCal3.TWetBulPriIn) annotation (Line(points={{-69,80},
          {-50,80},{-50,-84},{36,-84}},     color={0,0,127}));
  connect(TWetBulSupRam.y, indWetCal3.TWetBulSecIn) annotation (Line(points={{-69,-50},
          {-64,-50},{-64,-92},{36,-92}},      color={0,0,127}));
  connect(V_flowCon.y, indWetCal3.VPri_flow) annotation (Line(points={{-69,-10},
          {-40,-10},{-40,-96},{36,-96}}, color={0,0,127}));
  connect(V_flowCon.y, indWetCal3.VSec_flow) annotation (Line(points={{-69,-10},
          {-40,-10},{-40,-100},{36,-100}},
                                         color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This model implements a validation of the block <a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations\">Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations</a> that applies the peformance curve to calculate the water mass flow rate of a direct evaporative cooler. </p>
<p>This model considers three validation instances with: </p>
<ul>
<li>Time-varying inlet air dry bulb temperature <code>TDryBulIn</code>. </li>
<li>Time-varying inlet air wet bulb temperature <code>TWetBulIn</code>. </li>
<li>Time-varying inlet air volume flow rate <code>V_flow</code>. </li>
</ul>
<p>The pressure <code>p</code> is the atmospheric pressure for all the three validation instances. </p>
<p>The plots generated by the validation scripts show that the mass of water vapour 
added <code>dmWat_flow</code>, and hence the cooling rate, changes as follows. </p>
<ul>
<li>On plot 1, with constant values of <code>TWetBulIn</code>, <code>TDryBulIn</code>, 
and <code>p</code>, an increasing <code>V_flow</code> leads to decreasings in 
<code>eff</code> and <code>XiOut</code>. Since <code>V_flow</code> is the dominant 
term in the equations, this leads to an increase in <code>dmWat_flow</code>. </li>
<li>On plot 2, with constant values of <code>TDryBulIn</code>, <code>p</code>, and 
<code>V_flow</code>, an increasing <code>TWetBulIn</code> leads to an increase in 
<code>XiIn</code>. Based on the performance curve, <code>TDryBulOut</code> and 
<code>XiOut</code> keep constant.This results in an increase of <code>dmWat_flow</code>. </li>
<li>On plot 3, with constant values of <code>TWetBulIn</code>, <code>p</code>, and 
<code>V_flow</code>, an increasing <code>TDryBulIn</code> leads to a decrease in 
<code>XiIn</code>. Based on the performance curve, <code>TDryBulOut</code> and 
<code>XiOut</code> keep constant. This results in an increase of <code>dmWat_flow.</code></li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
    StopTime=60,
    Interval=1),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/Baseclasses/Validation/IndirectWetCalculations.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end IndirectWetCalculations;
