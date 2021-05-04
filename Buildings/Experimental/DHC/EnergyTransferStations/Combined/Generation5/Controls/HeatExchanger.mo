within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model HeatExchanger
  "District heat exchanger controller"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration conCon
    "District connection configuration"
    annotation (Evaluate=true);
  parameter Real spePum1HexMin(
    final unit="1",
    min=0)=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(enable=not have_val1Hex));
  parameter Real yVal1HexMin(
    final unit="1",
    min=0.01)=0.1
    "Minimum valve opening for temperature measurement (fractional)"
    annotation (Dialog(enable=have_val1Hex));
  parameter Real spePum2HexMin(
    final unit="1",
    min=0.01)=0.1
    "Heat exchanger secondary pump minimum speed (fractional)";
  parameter Modelica.SIunits.TemperatureDifference dT1HexSet[2]
    "Primary side deltaT set point schedule (index 1 for heat rejection)";
  parameter Real k[2]
    "Gain schedule for controller (index 1 for heat rejection)";
  final parameter Real kNor[2]=k ./ k[1]
    "Normalized gain schedule for controller (index 1 for heat rejection)";
  parameter Modelica.SIunits.Time Ti(
    min=0)
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatEnt(
    final unit="K",
    displayUnit="degC")
    "District heat exchanger primary water entering temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1HexWatLvg(
    final unit="K",
    displayUnit="degC")
    "District heat exchanger primary water leaving temperature"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1Hex(
    final unit="1")
    "District heat exchanger primary control signal"
    annotation (Placement(transformation(extent={{220,0},{260,40}}),iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum2Hex(
    final unit="1")
    "District heat exchanger secondary pump control signal"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal2Hex(
    final unit="1")
    "District heat exchanger secondary valve control signal"
    annotation (Placement(transformation(extent={{220,-80},{260,-40}}),iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT(
    k2=-1)
    "Compute deltaT"
    annotation (Placement(transformation(extent={{-170,-30},{-150,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs absDelT
    "Absolute value"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.Continuous.LimPID con1Hex(
    final k=1,
    final Ti=Ti,
    final reset=Buildings.Types.Reset.Parameter,
    final reverseActing=false,
    final yMin=0,
    final yMax=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Primary circuit controller"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum between control signal and minimum speed or opening"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff1
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant min1(
    final k=
      if have_val1Hex then
        yVal1HexMin
      else
        spePum1HexMin)
    "Minimum pump speed or actuator opening"
    annotation (Placement(transformation(extent={{50,-150},{70,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal for secondary side (from supervisory)"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.01,
    final h=0.005)
    "Check for heat or cold rejection demand"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "At least one valve is open and HX circuit is enabled"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold heaRej(
    final t=0.9,
    final h=0.1)
    "Heat rejection if condenser isolation valve is open"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cooRej(
    final t=0.9,
    final h=0.1)
    "Cold rejection if evaporator isolation valve is open"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "At least one valve is open "
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Gain scheduling"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={0,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    "Gain scheduling"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={36,-100})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger idxSch(
    integerTrue=2,
    integerFalse=1)
    "Conversion to integer for gain scheduling"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-80,-140})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant schSet[2](
    final k=dT1HexSet)
    "Set point schedule"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant schGai[2](
    k=kNor)
    "Gain schedule"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor setAct(
    nin=2)
    "Actual set point"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor gaiAct(
    nin=2)
    "Actual gain"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speMin(
    final k=spePum2HexMin)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapSpe
    "Mapping function for pump speed"
    annotation (Placement(transformation(extent={{90,130},{110,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1)
    "One"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(
    final k=0.3)
    "Control signal value for full opening of the valve"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapVal
    "Mapping function for valve opening"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
protected
  parameter Boolean have_val1Hex=conCon == Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  connect(delT.y,absDelT.u)
    annotation (Line(points={{-148,-20},{-92,-20}},color={0,0,127}));
  connect(T1HexWatEnt,delT.u1)
    annotation (Line(points={{-240,0},{-180,0},{-180,-14},{-172,-14}},color={0,0,127}));
  connect(T1HexWatLvg,delT.u2)
    annotation (Line(points={{-240,-40},{-180,-40},{-180,-26},{-172,-26}},color={0,0,127}));
  connect(swiOff1.y,y1Hex)
    annotation (Line(points={{182,-60},{190,-60},{190,20},{240,20}},color={0,0,127}));
  connect(max1.y,swiOff1.u1)
    annotation (Line(points={{112,-60},{126,-60},{126,-52},{158,-52}},color={0,0,127}));
  connect(u,greThr.u)
    annotation (Line(points={{-240,120},{-172,120}},color={0,0,127}));
  connect(greThr.y,and2.u1)
    annotation (Line(points={{-148,120},{-80,120},{-80,80},{-62,80}},color={255,0,255}));
  connect(and2.y,swiOff1.u2)
    annotation (Line(points={{-38,80},{140,80},{140,-60},{158,-60}},color={255,0,255}));
  connect(cooRej.y,or1.u2)
    annotation (Line(points={{-148,40},{-120,40},{-120,52},{-112,52}},color={255,0,255}));
  connect(heaRej.y,or1.u1)
    annotation (Line(points={{-148,80},{-120,80},{-120,60},{-112,60}},color={255,0,255}));
  connect(or1.y,and2.u2)
    annotation (Line(points={{-88,60},{-80,60},{-80,72},{-62,72}},color={255,0,255}));
  connect(yValIso[1],heaRej.u)
    annotation (Line(points={{-240,50},{-240,60},{-200,60},{-200,80},{-172,80}},color={0,0,127}));
  connect(yValIso[2],cooRej.u)
    annotation (Line(points={{-240,70},{-240,60},{-200,60},{-200,40},{-172,40}},color={0,0,127}));
  connect(and2.y,con1Hex.trigger)
    annotation (Line(points={{-38,80},{40,80},{40,-80},{52,-80},{52,-72}},color={255,0,255}));
  connect(pro1.y,con1Hex.u_m)
    annotation (Line(points={{48,-100},{60,-100},{60,-72}},color={0,0,127}));
  connect(absDelT.y,pro1.u1)
    annotation (Line(points={{-68,-20},{20,-20},{20,-94},{24,-94}},color={0,0,127}));
  connect(cooRej.y,idxSch.u)
    annotation (Line(points={{-148,40},{-140,40},{-140,-140},{-92,-140}},color={255,0,255}));
  connect(schSet.y,setAct.u)
    annotation (Line(points={{-68,-60},{-52,-60}},color={0,0,127}));
  connect(schGai.y,gaiAct.u)
    annotation (Line(points={{-68,-100},{-52,-100}},color={0,0,127}));
  connect(gaiAct.y,pro.u2)
    annotation (Line(points={{-28,-100},{-20,-100},{-20,-66},{-12,-66}},color={0,0,127}));
  connect(gaiAct.y,pro1.u2)
    annotation (Line(points={{-28,-100},{20,-100},{20,-106},{24,-106}},color={0,0,127}));
  connect(idxSch.y,gaiAct.index)
    annotation (Line(points={{-68,-140},{-40,-140},{-40,-112}},color={255,127,0}));
  connect(idxSch.y,setAct.index)
    annotation (Line(points={{-68,-140},{-60,-140},{-60,-80},{-40,-80},{-40,-72}},color={255,127,0}));
  connect(con1Hex.y,max1.u1)
    annotation (Line(points={{71,-60},{80,-60},{80,-54},{88,-54}},color={0,0,127}));
  connect(min1.y,max1.u2)
    annotation (Line(points={{72,-140},{80,-140},{80,-66},{88,-66}},color={0,0,127}));
  connect(swiOff2.y,yPum2Hex)
    annotation (Line(points={{182,140},{200,140},{200,-20},{240,-20}},color={0,0,127}));
  connect(one.y,mapSpe.x2)
    annotation (Line(points={{62,100},{70,100},{70,136},{88,136}},color={0,0,127}));
  connect(one.y,mapSpe.f2)
    annotation (Line(points={{62,100},{70,100},{70,132},{88,132}},color={0,0,127}));
  connect(u,mapSpe.u)
    annotation (Line(points={{-240,120},{-180,120},{-180,140},{88,140}},color={0,0,127}));
  connect(speMin.y,mapSpe.f1)
    annotation (Line(points={{12,160},{70,160},{70,144},{88,144}},color={0,0,127}));
  connect(mapSpe.y,swiOff2.u1)
    annotation (Line(points={{112,140},{120,140},{120,148},{158,148}},color={0,0,127}));
  connect(pro.y,con1Hex.u_s)
    annotation (Line(points={{12,-60},{48,-60}},color={0,0,127}));
  connect(setAct.y,pro.u1)
    annotation (Line(points={{-28,-60},{-20,-60},{-20,-54},{-12,-54}},color={0,0,127}));
  connect(zer.y,swiOff2.u3)
    annotation (Line(points={{12,40},{120,40},{120,132},{158,132}},color={0,0,127}));
  connect(zer.y,swiOff1.u3)
    annotation (Line(points={{12,40},{120,40},{120,-68},{158,-68}},color={0,0,127}));
  connect(hal.y,mapSpe.x1)
    annotation (Line(points={{12,100},{20,100},{20,148},{88,148}},color={0,0,127}));
  connect(u,mapVal.u)
    annotation (Line(points={{-240,120},{-180,120},{-180,140},{84,140},{84,100},{88,100}},color={0,0,127}));
  connect(zer.y,mapVal.x1)
    annotation (Line(points={{12,40},{80,40},{80,108},{88,108}},color={0,0,127}));
  connect(zer.y,mapVal.f1)
    annotation (Line(points={{12,40},{80,40},{80,104},{88,104}},color={0,0,127}));
  connect(one.y,mapVal.f2)
    annotation (Line(points={{62,100},{70,100},{70,92},{88,92}},color={0,0,127}));
  connect(hal.y,mapVal.x2)
    annotation (Line(points={{12,100},{20,100},{20,84},{84,84},{84,96},{88,96}},color={0,0,127}));
  connect(mapVal.y,yVal2Hex)
    annotation (Line(points={{112,100},{210,100},{210,-60},{240,-60}},color={0,0,127}));
  connect(and2.y,swiOff2.u2)
    annotation (Line(points={{-38,80},{-20,80},{-20,120},{130,120},{130,140},{158,140}},color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-180},{220,180}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the control logic for the district heat exchanger,
which realizes the interface between the building system and the district system.
</p>
<p>
The input signal <code>u</code> is yielded by the supervisory controller, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory</a>.
The primary and secondary circuits are enabled to operate if this input signal
is greater than zero and the return position of at least one isolation valve
is greater than 90%.
When enabled,
</p>
<ul>
<li>
the secondary circuit is controlled based on the input signal <code>u</code>,
which is mapped to modulate in sequence the mixing valve
(from full bypass to closed bypass for a control signal varying between
0% and 30%) and the pump speed (from the minimum to the maximum value
for a control signal varying between 30% and 100%),
</li>
<li>
the primary pump speed (or valve opening) is modulated with
a PI loop controlling the temperature difference across the primary side
of the heat exchanger.
A set point (and gain) scheduling logic is implemented to allow changing the
control parameters based on the active rejection mode (heat or cold rejection)
of the ETS.
</li>
</ul>
<p>
Note that the valve on the secondary side is needed to stabilize the control
of the system when the secondary mass flow rate required to meet the heat or
cold rejection demand is below the flow rate corresponding to the minimum pump speed.
</p>
</html>"));
end HeatExchanger;
