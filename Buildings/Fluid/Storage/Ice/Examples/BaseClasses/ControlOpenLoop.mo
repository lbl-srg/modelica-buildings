within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlOpenLoop "Open loop control for ice storage plant"
  Controls.OBC.CDL.Logical.Sources.Constant tru(k=true) "Outputs true"
    annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yTru "Outputs true"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yFal "Outputs false"
    annotation (Placement(transformation(extent={{100,-140},{140,-100}})));
  Controls.OBC.CDL.Interfaces.RealOutput TChiWatSet(
    final unit = "K",
    displayUnit= "degC")
    "Setpoint chiller water leaving temperature"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Controls.OBC.CDL.Interfaces.RealOutput TChiGlySet(
    final unit = "K",
    displayUnit= "degC") "Setpoint chiller glycol leaving temperature"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 15.2)
    "Set point"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Controls.OBC.CDL.Logical.Sources.Constant fal(k=false) "Outputs false"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Controls.OBC.CDL.Interfaces.RealOutput yStoOn
    "Control signal for storage main leg"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Continuous.Subtract sub
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Outputs one"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Controls.OBC.CDL.Conversions.BooleanToReal valStoByp(realTrue=1, realFalse=0)
    "Control signal to enable discharging storage"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Controls.OBC.CDL.Interfaces.RealOutput yStoByp
    "Control signal for storage bypass leg"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
equation
  connect(chiWatTSet.y, TChiWatSet)
    annotation (Line(points={{62,80},{120,80}}, color={0,0,127}));
  connect(chiGlyTSet.y, TChiGlySet)
    annotation (Line(points={{62,40},{120,40}}, color={0,0,127}));
  connect(tru.y, yTru)
    annotation (Line(points={{-70,-80},{120,-80}}, color={255,0,255}));
  connect(fal.y, yFal)
    annotation (Line(points={{62,-120},{120,-120}}, color={255,0,255}));
  connect(valStoByp.y, sub.u2) annotation (Line(points={{-28,-60},{-22,-60},{
          -22,-36},{-12,-36}}, color={0,0,127}));
  connect(one.y, sub.u1) annotation (Line(points={{-28,-10},{-20,-10},{-20,-24},
          {-12,-24}}, color={0,0,127}));
  connect(one.y, yStoOn) annotation (Line(points={{-28,-10},{40,-10},{40,0},{
          120,0}}, color={0,0,127}));
  connect(sub.y, yStoByp) annotation (Line(points={{12,-30},{58,-30},{58,-40},{
          120,-40}}, color={0,0,127}));
  connect(valStoByp.u, tru.y) annotation (Line(points={{-52,-60},{-60,-60},{-60,
          -80},{-70,-80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -140},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-50,154},{50,110}},
          textColor={0,0,127},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,
            100}})));
end ControlOpenLoop;
