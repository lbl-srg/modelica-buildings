within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block OccupiedMinAirflowReheatBox
  "Output the occupied minimum airflow for VAV reheat terminal unit"

  parameter Boolean occSen = true
    "Set to true if the zone has occupancy sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean winSen = true
    "Set to true if the zone has window operation sensor and window is open"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean co2Sen = true
    "Set to true if the zone has CO2 sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Modelica.SIunits.VolumeFlowRate VCooMax
    "Zone maximum cooling airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMin
    "Zone minimum airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax
    "Zone maximum heating airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference MaxdT
    "Zone maximum discharge air temperature above heating setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon
    "VAV box controllable minimum"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area zonAre "Area of the zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Real outAirPerAre(final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter real co2Set = 894 "CO2 setpoints"
    annotation(Dialog(group="Nominal condition"));

  CDL.Interfaces.RealInput nOcc(final unit="1") if occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-300,-10},{-260,30}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput ppmCO2(final unit="1") if co2Sen
    "Detected CO2 conventration"
    annotation (Placement(transformation(extent={{-300,90},{-260,130}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.BooleanInput uWin if winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-300,-230},{-260,-190}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  CDL.Interfaces.RealOutput VOccMinAir(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Occupied minimum airflow "
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Continuous.Gain gai(k=outAirPerPer) if occSen
  "Outdoor air per person"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  CDL.Continuous.Add breZon if occSen
  "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Line lin if co2Sen
    "Maintain CO2 concentration at setpoint, reset 0% at (setpoint-200) and 100% at setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Line lin1 if co2Sen
    "Reset occupied minimum airflow setpoint from 0% at VMin and 100% at VCooMax"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  CDL.Continuous.Greater gre
    "Check if zone minimum airflow setpoint Vmin is less than the allowed controllable VMinCon"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=1) if occSen
    "Check if the zone becomes unpopulated"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  CDL.Continuous.GreaterThreshold greThr1
    "Check if zone minimum airflow setpoint VMin is non-zero"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  CDL.Logical.Switch swi
    "Reset occupied minimum airflow according to occupancy"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  CDL.Logical.Switch swi1
    "Reset occupied minimum airflow according to window status"
    annotation (Placement(transformation(extent={{200,-220},{220,-200}})));
  CDL.Logical.Switch swi2
    "Reset occupied minimum airflow setpoint according to minimum controllable airflow"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  CDL.Logical.Switch swi3 if co2Sen
    "Switch between zero signal and CO2 control loop signal depending on the operation mode"
    annotation (Placement(transformation(extent={{-80,190},{-60,170}})));
  CDL.Integers.Equal intEqu if co2Sen
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  CDL.Logical.Not not2 if winSen "Logical not"
    annotation (Placement(transformation(extent={{-240,-220},{-220,-200}})));

protected
  CDL.Continuous.Sources.Constant minZonAir1(k=VMin) if not co2Sen
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  CDL.Continuous.Sources.Constant maxZonCooAir(k=VCooMax) if co2Sen
    "Zone maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  CDL.Continuous.Sources.Constant breZonAre(k=outAirPerAre*zonAre) if occSen
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Continuous.Sources.Constant conVolMin(k=VMinCon)
    "VAV box controllable minimum"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  CDL.Continuous.Sources.Constant minZonAir(k=VMin)
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-240,230},{-220,250}})));
  CDL.Continuous.Sources.Constant setCO1(k=co2Set - 200) if co2Sen
    "CO2 setpoints minus 200"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  CDL.Continuous.Sources.Constant setCO2(k=co2Set) if co2Sen
    "CO2 setpoints"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
  CDL.Continuous.Sources.Constant zerFlo(k=0)
    "Zero airflow when window is open"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  CDL.Logical.Sources.Constant con(k=true) if not occSen "Constant true"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Sources.Constant con1(k=true) if not winSen "Constant true"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  CDL.Integers.Sources.Constant conInt(
    k=Constants.OperationModes.occModInd) if co2Sen
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-240,190},{-220,210}})));
  CDL.Continuous.Sources.Constant zerCon(k=0) "Output zero"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));
  CDL.Continuous.Sources.Constant zerCon1(k=0) if co2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  CDL.Continuous.Sources.Constant zerCon2(k=0) if co2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  CDL.Continuous.Sources.Constant zerCon3(k=0) if not occSen
    "Output zero"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Continuous.Sources.Constant oneCon(k=1) if co2Sen
    "Output one"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  CDL.Continuous.Sources.Constant oneCon1(k=1) if co2Sen "Output one"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

equation
  connect(conVolMin.y, gre.u1)
    annotation (Line(points={{-59,-140},{-40,-140},{-40,-160},{-22,-160}},
      color={0,0,127}));
  connect(setCO1.y, lin.x1)
    annotation (Line(points={{-219,160},{-160,160},{-160,118},{-142,118}},
      color={0,0,127}));
  connect(zerCon.y, lin.f1)
    annotation (Line(points={{-219,130},{-180,130},{-180,114},{-142,114}},
      color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-280,110},{-142,110}},  color={0,0,127}));
  connect(setCO2.y, lin.x2)
    annotation (Line(points={{-219,90},{-180,90},{-180,106},{-142,106}},
      color={0,0,127}));
  connect(oneCon.y, lin.f2)
    annotation (Line(points={{-219,60},{-160,60},{-160,102},{-142,102}},
      color={0,0,127}));
  connect(zerCon1.y, lin1.x1)
    annotation (Line(points={{-59,210},{0,210},{0,178},{18,178}},
      color={0,0,127}));
  connect(oneCon1.y, lin1.x2)
    annotation (Line(points={{-59,140},{-20,140},{-20,166},{18,166}},
      color={0,0,127}));
  connect(maxZonCooAir.y, lin1.f2)
    annotation (Line(points={{-59,110},{0,110},{0,162},{18,162}},
      color={0,0,127}));
  connect(minZonAir.y, lin1.f1)
    annotation (Line(points={{-219,240},{-20,240},{-20,174},{18,174}},
      color={0,0,127}));
  connect(intEqu.y, swi3.u2)
    annotation (Line(points={{-119,180},{-82,180}}, color={255,0,255}));
  connect(lin.y, swi3.u1)
    annotation (Line(points={{-119,110},{-100,110},{-100,172},{-82,172}},
      color={0,0,127}));
  connect(swi3.y, lin1.u)
    annotation (Line(points={{-59,180},{-40,180},{-40,170},{18,170}},
      color={0,0,127}));
  connect(zerCon2.y, swi3.u3)
    annotation (Line(points={{-119,210},{-100,210},{-100,188},{-82,188}},
      color={0,0,127}));
  connect(uOpeMod, intEqu.u2)
    annotation (Line(points={{-280,180},{-180,180},{-180,172},{-142,172}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-219,200},{-160,200},{-160,180},{-142,180}},
      color={255,127,0}));
  connect(nOcc, greThr.u)
    annotation (Line(points={{-280,10},{-142,10}}, color={0,0,127}));
  connect(nOcc, gai.u)
    annotation (Line(points={{-280,10},{-160,10},{-160,-30},{-142,-30}},
      color={0,0,127}));
  connect(breZonAre.y, breZon.u2)
    annotation (Line(points={{-119,-70},{-100,-70},{-100,-56},{-82,-56}},
      color={0,0,127}));
  connect(gai.y, breZon.u1)
    annotation (Line(points={{-119,-30},{-100,-30},{-100,-44},{-82,-44}},
      color={0,0,127}));
  connect(breZon.y, swi.u3)
    annotation (Line(points={{-59,-50},{-20,-50},{-20,2},{78,2}},
      color={0,0,127}));
  connect(greThr.y, swi.u2)
    annotation (Line(points={{-119,10},{78,10}}, color={255,0,255}));
  connect(lin1.y, swi.u1)
    annotation (Line(points={{41,170},{60,170},{60,18},{78,18}},
      color={0,0,127}));
  connect(minZonAir.y, greThr1.u)
    annotation (Line(points={{-219,240},{-200,240},{-200,-110},{-82,-110}},
      color={0,0,127}));
  connect(minZonAir.y, gre.u2)
    annotation (Line(points={{-219,240},{-200,240},{-200,-168},{-22,-168}},
      color={0,0,127}));
  connect(gre.y,and1. u2)
    annotation (Line(points={{1,-160},{20,-160},{20,-118},{38,-118}},
      color={255,0,255}));
  connect(greThr1.y,and1. u1)
    annotation (Line(points={{-59,-110},{38,-110}}, color={255,0,255}));
  connect(and1.y, not1.u)
    annotation (Line(points={{61,-110},{78,-110}}, color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{101,-110},{138,-110}}, color={255,0,255}));
  connect(conVolMin.y, swi2.u3)
    annotation (Line(points={{-59,-140},{120,-140},{120,-118},{138,-118}},
      color={0,0,127}));
  connect(swi.y, swi2.u1)
    annotation (Line(points={{101,10},{120,10},{120,-102},{138,-102}},
      color={0,0,127}));
  connect(uWin, not2.u)
    annotation (Line(points={{-280,-210},{-242,-210}}, color={255,0,255}));
  connect(not2.y, swi1.u2)
    annotation (Line(points={{-219,-210},{198,-210}}, color={255,0,255}));
  connect(zerFlo.y, swi1.u3)
    annotation (Line(points={{161,-240},{180,-240},{180,-218},{198,-218}},
      color={0,0,127}));
  connect(swi2.y, swi1.u1)
    annotation (Line(points={{161,-110},{180,-110},{180,-202},{198,-202}},
      color={0,0,127}));
  connect(swi1.y, VOccMinAir)
    annotation (Line(points={{221,-210},{240,-210},{240,0},{280,0}},
      color={0,0,127}));
  connect(con.y, swi.u2)
    annotation (Line(points={{-59,30},{-40,30},{-40,10},{78,10}},
      color={255,0,255}));
  connect(minZonAir1.y, swi.u1)
    annotation (Line(points={{41,240},{60,240},{60,18},{78,18}},
      color={0,0,127}));
  connect(con1.y, swi1.u2)
    annotation (Line(points={{61,-190},{80,-190},{80,-210},{198,-210}},
      color={255,0,255}));
  connect(zerCon3.y, swi.u3)
    annotation (Line(points={{21,-50},{40,-50},{40,2},{78,2}},
      color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-260},{260,260}})), Icon(
        graphics={
               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,130},{96,108}},
          lineColor={0,0,255},
          textString="%name"),            Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="occMinAir")}));
end OccupiedMinAirflowReheatBox;
