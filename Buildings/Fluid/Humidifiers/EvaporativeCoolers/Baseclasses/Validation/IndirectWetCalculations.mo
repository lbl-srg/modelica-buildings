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
          -100},{-54,-100},{-54,-48},{36,-48}}, color={0,0,127}));
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
  <p>This model implements a validation of the block 
  <a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations\">
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.IndirectWetCalculations</a> 
  that calculates the outlet drybulb temoerature using measurements from the fluid 
  streams and empirically determined perfromace coefficients.</p>
<p>This model considers four validation instances with: </p>
<ul>
<li>Time-varying primary fluid volume flowrate <code>VPri_flow</code>. </li>
<li>Time-varying secondary air volume flowrate <code>VSec_flow</code>. </li>
<li>Time-varying secondary air inlet drybulb temperature <code>TDryBulSecIn</code>. </li>
<li>Time-varying secondary air inlet wetbulb temperature <code>TWetBulSecIn</code>. </li>
</ul>
<p>The primary fluid inlet temperatures <code>TDryBulPriIn</code> and <code>TWetBulPriIn</code>
are kept constant in all cases since they don't affect the heat-transfer performance. </p>
<p>The plots generated by the validation scripts show that the outlet primary fluid 
drybulb temperature <code>TDryBulPriOut</code>, and hence the cooling rate, changes as follows. </p>
<ul>
<li>On plot 1, an increasing <code>VPri_flow</code> leads to an increase in 
<code>TDryBulPriOut</code>. </li>
<li>On plot 2, an increasing <code>VSec_flow</code> results in a decrease in 
<code>TDryBulPriOut</code>. </li>
<li>On plot 3, an increasing <code>TDryBulSecIn</code> leads to a decrease in 
<code>TDryBulPriOut.</code></li>
<li>On plot 4, an increasing <code>TWetBulSecIn</code> leads to an increase in 
<code>TDryBulPriOut.</code></li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023 by Karthikeya Devaprasad:<br/>
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
