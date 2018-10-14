within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Status
  "Determines chiller stage based on the previous stage and the current capacity requirement. fixme: stagin up and down process (delays, etc) should be added."

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real minPlrSta1 = 0.1
  "Minimal part load ratio of the first stage";

  parameter Real capSta1 = 3.517*1000*310
  "Capacity of stage 1";

  parameter Real capSta2 = 2*capSta1
  "Capacity of stage 2";

  parameter Real staUpPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Minimum operating part load ratio of the next lower stage before staging down";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min = 0,
    final max = numSta)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
    iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta(
    final min=0,
    final max=numSta)
    "Chiller stage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.Capacities staCap(
    final min_plr1=minPlrSta1,
    final nomCapSta1=capSta1,
    final nomCapSta2=capSta2)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.ChangePositiveDisplacement
    staChaPosDis(
    final staUpPlr=staUpPlr,
    final staDowPlr=staDowPlr)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.CapacityRequirement capReq
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  CDL.Integers.Add addInt(k2=+1)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(uChiSta, addInt.u2) annotation (Line(points={{-120,60},{-80,60},{-80,10},
          {-10,10},{-10,-6},{58,-6}},     color={255,127,0}));
  connect(addInt.y, yChiSta)
    annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
  connect(uChiSta, staCap.uChiSta) annotation (Line(points={{-120,60},{-60,60},{
          -60,30},{-42,30}}, color={255,127,0}));
  connect(staChaPosDis.yChiStaCha, addInt.u1) annotation (Line(points={{41,50},{
          50,50},{50,6},{58,6}}, color={255,127,0}));
  connect(uChiSta, staChaPosDis.uChiSta) annotation (Line(points={{-120,60},{-20,
          60},{-20,58},{19,58}}, color={255,127,0}));
  connect(staCap.yCapNomSta, staChaPosDis.uCapNomSta) annotation (Line(points={{
          -19,34},{-10,34},{-10,53},{19,53}}, color={0,0,127}));
  connect(staCap.yCapNomLowSta, staChaPosDis.uCapNomLowSta) annotation (Line(
        points={{-19,26},{-4,26},{-4,49},{19,49}}, color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-120,0},
          {-80,0},{-80,-25},{-41,-25}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-120,-40},{-80,
          -40},{-80,-30},{-41,-30}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-120,-80},
          {-70,-80},{-70,-35},{-41,-35}}, color={0,0,127}));
  connect(capReq.yCapReq, staChaPosDis.uCapReq) annotation (Line(points={{-19,-30},
          {0,-30},{0,45},{19,45}}, color={0,0,127}));
  annotation (defaultComponentName = "chiSta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Fixme
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Status;
