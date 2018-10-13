within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Status
  "Determines chiller stage based on the previous stage and the current capacity requirement. fixme: stagin up and down process (delays, etc) should be added."

  parameter Integer numSta = 2
  "Number of stages";

  CapacityRequirement capacityRequirement
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  CDL.Interfaces.IntegerInput                        uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));
  CDL.Integers.Add addInt(k2=+1)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.IntegerOutput yChiSta(final min=0, final max=numSta)
    "Chiller stage" annotation (Placement(transformation(extent={{100,-10},{120,
            10}}), iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s") "Measured chilled water flow rate" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity=
        "ThermodynamicTemperature") "Chilled water supply setpoint temperature"
                                                annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-120,40},{-100,60}})));
  Capacities staCap
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  StageChangePositiveDisplacement chiChaPosDis
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(VChiWat_flow, capacityRequirement.VChiWat_flow) annotation (Line(
        points={{-120,-80},{-70,-80},{-70,-24},{-21,-24}}, color={0,0,127}));
  connect(TChiWatRet, capacityRequirement.TChiWatRet) annotation (Line(points={{-120,
          -40},{-60,-40},{-60,-27},{-21,-27}},       color={0,0,127}));
  connect(TChiWatSupSet, capacityRequirement.TChiWatSupSet) annotation (Line(
        points={{-120,0},{-40,0},{-40,-30},{-21,-30}}, color={0,0,127}));
  connect(uChiSta, addInt.u2) annotation (Line(points={{-120,60},{-80,60},{-80,
          10},{-12,10},{-12,-6},{58,-6}}, color={255,127,0}));
  connect(addInt.y, yChiSta)
    annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
  connect(uChiSta, staCap.uChiSta) annotation (Line(points={{-120,60},{-74,60},
          {-74,30},{-62,30}}, color={255,127,0}));
  connect(chiChaPosDis.yChiStaCha, addInt.u1) annotation (Line(points={{41,50},
          {50,50},{50,6},{58,6}}, color={255,127,0}));
  connect(uChiSta, chiChaPosDis.uChiSta) annotation (Line(points={{-120,60},{
          -50,60},{-50,58},{19,58}}, color={255,127,0}));
  connect(staCap.yCapNomSta, chiChaPosDis.uCapNomSta) annotation (Line(points={
          {-39,34},{-10,34},{-10,53},{19,53}}, color={0,0,127}));
  connect(staCap.yCapNomLowSta, chiChaPosDis.uCapNomLowSta) annotation (Line(
        points={{-39,26},{-10,26},{-10,49},{19,49}}, color={0,0,127}));
  connect(capacityRequirement.yCapReq, chiChaPosDis.uCapReq) annotation (Line(
        points={{1,-30},{10,-30},{10,45},{19,45}}, color={0,0,127}));
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
