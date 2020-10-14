within Buildings.Controls.OBC.FDE.DOAS.Validation;
model DOAScontroller "DOAS controller"

  parameter Real erwEff(
    final min=0,
    final max=1)=0.8
   "ERW efficiency parameter."
   annotation (Dialog(tab="DOAS", group="General"));

 parameter Boolean vvUnit = true
   "Set true when unit serves variable volume system."
   annotation (Dialog(tab="DOAS", group="General"));

 parameter Real damSet(
   final min=0,
   final max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point"
   annotation (Dialog(tab="DOAS", group="General"));

  parameter Real cctPIk = 0.0000001
  "Cooling coil CCT PI gain value k."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real cctPITi = 0.0075
  "Cooling coil CCT PI time constant value Ti."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real SAccPIk = 0.0000001
  "Cooling coil SAT PI gain value k."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real SAccPITi = 0.0075
  "Cooling coil SAT PI time constant value Ti."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real dehumSet(
    final min=0,
    final max=100)=60
   "Dehumidification set point."
    annotation (Dialog(tab="Dehumidification", group="Set Point"));

  parameter Real dehumDelay(
    final unit="s",
    final quantity="Time")=600
    "Minimum delay after RH falls below set point before turning dehum off."
     annotation (Dialog(tab="Dehumidification", group="Timer"));

  parameter Real minRun(
    final unit="s",
    final quantity="Time")=120
    "Minimum supply fan proof delay before allowing dehum mode."
     annotation (Dialog(tab="Dehumidification", group="Timer"));

  parameter Real econCooAdj(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=2
    "Value subtracted from supply air temperature cooling set point."
     annotation (Dialog(tab="Economizer", group="Set Point"));

 parameter Real erwDPadj(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=5
    "Value subtracted from ERW supply air dewpoint."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Set Point"));

 parameter Real recSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=7
    "Energy recovery set point."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Set Point"));

 parameter Real recSetDelay(
    final unit="s",
    final quantity="Time")=300
    "Minimum delay after OAT/RAT delta falls below set point."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Timer"));

 parameter Real kGain(
    final unit="1")=0.00001
    "PID loop gain value."
    annotation (Dialog(tab="Energy Recovery Wheel", group="PID"));

 parameter Real conTi(
    final unit="s")=0.00025
    "PID time constant of integrator."
    annotation (Dialog(tab="Energy Recovery Wheel", group="PID"));

 parameter Real SArhcPIk = 0.0000001
  "Heating coil SAT PI gain value k."
  annotation (Dialog(tab="Heating Coil", group="PI Parameters"));

 parameter Real SArhcPITi = 0.0075
  "Heating coil SAT PI time constant value Ti."
  annotation (Dialog(tab="Heating Coil", group="PI Parameters"));

 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=125
    "Minimum down duct static pressure reset value"
      annotation (Dialog(tab="Pressure", group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=500
    "Maximum down duct static pressure reset value"
      annotation (Dialog(tab="Pressure", group="DDSP range"));

  parameter Real cvDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=250
    "Constant volume down duct static pressure set point"
      annotation (Dialog(tab="Pressure", group="CV DDSP"));

 parameter Real bldgSPset(
   final unit="Pa",
   final quantity="PressureDifference")=15
    "Building static pressure set point"
    annotation (Dialog(tab="Pressure", group="Building"));

 parameter Real loPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+20
   "Minimum primary supply air temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real hiPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+24
   "Maximum primary supply air temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real hiZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+25
   "Maximum zone temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real loZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+21
   "Minimum zone temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real coAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature cooling set point offset."
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real heAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature heating set point offset."
   annotation (Dialog(tab="Temperature", group="Set Point"));

  Buildings.Controls.OBC.FDE.DOAS.DOAScontroller DOAScon(
    cctPIk=0.001,
    cctPITi=0.025,
    SAccPIk=0.001,
    SAccPITi=0.025)
    annotation (Placement(transformation(extent={{64,-18},{84,16}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen(
    width=0.8,
    period=8000,
    startTime=1000)
      "Simulates occupancy mode schedule."
      annotation (Placement(transformation(extent={{-42,76},{-22,96}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
    amplitude=4,
    freqHz=1/5670,
    offset=90)
      "Simulates changing terminal unit most open damper position."
      annotation (Placement(transformation(extent={{-42,46},{-22,66}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=10,
    delayOnInit=true)
    "Simulates delay from initial fan start command to fan status proof."
      annotation (Placement(transformation(extent={{-94,14},{-74,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sensorDDSP(
    amplitude=300,
    freqHz=1/10800,
    phase=3.9269908169872,
    offset=400)
      annotation (Placement(transformation(extent={{-92,-18},{-72,2}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logic switch selects DDSP generator when fan is proven otherwise selects 0."
    annotation (Placement(transformation(extent={{-52,-2},{-32,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(
    final k=0) "Real constant 0"
    annotation (Placement(transformation(extent={{-92,-48},{-72,-28}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ralHumGen(
    amplitude=10,
    freqHz=1/10800,
    phase=1.5707963267949,
    offset=60,
    startTime=0)
    "Return humidity sensor simulator."
      annotation (Placement(transformation(extent={{2,-16},{22,4}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine erwHumGen(
    amplitude=5,
    freqHz=1/7200,
    phase=1.5707963267949,
    offset=60,
    startTime=0)
    "ERW humidity sensor simulator."
      annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10,
    final delayOnInit=true)
    "Simulates delay from initial fan start command to fan status proof."
    annotation (Placement(transformation(extent={{108,-66},{128,-46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine bldgSP(
    amplitude=3,
    freqHz=1/10800,
    offset=15)
    annotation (Placement(transformation(extent={{30,-92},{50,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine  ccTGen(
    amplitude=7,
    freqHz=1/21600,
    phase=1.0471975511966,
    offset=283,
    startTime=0)
    "Cooling coil discharge temperature simulator."
    annotation (Placement(transformation(extent={{-24,-92},{-4,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oaTgen(
    height=26,
    duration=8500,
    offset=275,
    startTime=500)
    "Outside air temperature generator."
    annotation (Placement(transformation(extent={{4,-46},{24,-26}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine raTGen(
    amplitude=5,
    freqHz=1/20600,
    phase=0.34906585039887,
    offset=294,
    startTime=0)
    "Return air temperature simulator."
      annotation (Placement(transformation(extent={{-52,-30},{-32,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine highSpaceTGen(
    amplitude=3,
    freqHz=1/3600,
    offset=296,
    startTime=1250)
    "Terminal unit high space temperature simulator."
      annotation (Placement(transformation(extent={{-24,-28},{-4,-8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine saTGen(
    amplitude=15,
    freqHz=1/21600,
    phase=1.0471975511966,
    offset=285,
    startTime=0) "Supply air temperature simulator."
    annotation (Placement(transformation(extent={{-24,-62},{-4,-42}})));
  Buildings.Controls.OBC.FDE.DOAS.erwTsim ERWtemp
    "Energy recovery wheel supply temperature simulator."
    annotation (Placement(transformation(extent={{110,-28},{130,-8}})));

equation
  connect(OccGen.y, DOAScon.occ) annotation (Line(points={{-20,86},{58,86},{58,
          15.6},{62,15.6}}, color={255,0,255}));
  connect(mostOpenDamGen.y, DOAScon.mostOpenDam) annotation (Line(points={{-20,
          56},{54,56},{54,13.2},{62,13.2}}, color={0,0,127}));
  connect(truDel.y, DOAScon.supFanStatus) annotation (Line(points={{-72,24},{50,
          24},{50,10.8},{62,10.8}}, color={255,0,255}));
  connect(DOAScon.supFanStart, truDel.u) annotation (Line(points={{86.2,11.4},{
          92,11.4},{92,40},{-98,40},{-98,24},{-96,24}}, color={255,0,255}));
  connect(truDel.y, swi.u2) annotation (Line(points={{-72,24},{-60,24},{-60,8},
          {-54,8}}, color={255,0,255}));
  connect(sensorDDSP.y, swi.u1) annotation (Line(points={{-70,-8},{-66,-8},{-66,
          16},{-54,16}}, color={0,0,127}));
  connect(con0.y, swi.u3) annotation (Line(points={{-70,-38},{-60,-38},{-60,0},
          {-54,0}}, color={0,0,127}));
  connect(ralHumGen.y, DOAScon.retHum)
    annotation (Line(points={{24,-6},{28,-6},{28,6},{62,6}}, color={0,0,127}));
  connect(highSpaceTGen.y, DOAScon.highSpaceT) annotation (Line(points={{-2,-18},
          {30,-18},{30,3.4},{62,3.4}}, color={0,0,127}));
  connect(raTGen.y, DOAScon.raT) annotation (Line(points={{-30,-20},{-28,-20},{-28,
          -1.6},{62,-1.6}},     color={0,0,127}));
  connect(erwHumGen.y, DOAScon.erwHum) annotation (Line(points={{54,-20},{56,-20},
          {56,-9.2},{62,-9.2}}, color={0,0,127}));
  connect(DOAScon.bypDam, ERWtemp.bypDam) annotation (Line(points={{86.2,-1},{97.1,
          -1},{97.1,-12},{107.6,-12}}, color={255,0,255}));
  connect(DOAScon.erwStart, ERWtemp.erwStart) annotation (Line(points={{86.2,-4},
          {98,-4},{98,-16},{107.6,-16}}, color={255,0,255}));
  connect(raTGen.y, ERWtemp.raT) annotation (Line(points={{-30,-20},{107.6,-20}},
                             color={0,0,127}));
  connect(ERWtemp.erwTsim, DOAScon.erwT) annotation (Line(points={{132.4,-18},{134,
          -18},{134,-38},{60,-38},{60,-11.6},{62,-11.6}}, color={0,0,127}));
  connect(DOAScon.exhFanStart, truDel1.u) annotation (Line(points={{86.2,-10.4},
          {96,-10.4},{96,-56},{106,-56}}, color={255,0,255}));
  connect(truDel1.y, DOAScon.exhFanProof) annotation (Line(points={{130,-56},{134,
          -56},{134,-74},{58,-74},{58,-14},{62,-14}}, color={255,0,255}));
  connect(bldgSP.y, DOAScon.bldgSP) annotation (Line(points={{52,-82},{54,-82},{
          54,-16.4},{62,-16.4}}, color={0,0,127}));
  connect(oaTgen.y, DOAScon.oaT) annotation (Line(points={{26,-36},{32,-36},{32,
          -4.2},{62,-4.2}}, color={0,0,127}));
  connect(oaTgen.y, ERWtemp.oaT) annotation (Line(points={{26,-36},{62,-36},{62,
          -24},{107.6,-24}}, color={0,0,127}));
  connect(swi.y, DOAScon.DDSP) annotation (Line(points={{-30,8},{16,8},{16,8.4},
          {62,8.4}}, color={0,0,127}));
  connect(saTGen.y, DOAScon.saT) annotation (Line(points={{-2,-52},{26,-52},{26,
          0.8},{62,0.8}}, color={0,0,127}));
  connect(ccTGen.y, DOAScon.ccT) annotation (Line(points={{-2,-82},{28,-82},{28,
          -6.6},{62,-6.6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 28, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.DOAScontroller\">
Buildings.Controls.OBC.FDE.DOAS.DOAScontroller</a>.
</p>
</html>"),
    experiment(StopTime=10800, __Dymola_Algorithm="Dassl"));
end DOAScontroller;
