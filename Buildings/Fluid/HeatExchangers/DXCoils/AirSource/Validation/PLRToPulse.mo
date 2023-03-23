within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
block PLRToPulse
 Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=3600)
   annotation (Placement(transformation(extent={{-20,60},{0,80}})));
 Buildings.Controls.OBC.CDL.Logical.Latch lat
   annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
 Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(period=3600)
   annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
 Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
   annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
 Buildings.Controls.OBC.CDL.Logical.Timer tim
   annotation (Placement(transformation(extent={{-20,28},{0,48}})));
 Modelica.Blocks.Logical.GreaterEqual             greaterEqual
   annotation (Placement(transformation(extent={{40,50},{60,70}})));
 Buildings.Controls.OBC.CDL.Logical.Pre pre
   annotation (Placement(transformation(extent={{70,50},{90,70}})));
 Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y annotation (Placement(transformation(extent={{100,-22},
            {140,18}}),   iconTransformation(extent={{100,-22},{140,18}})));
 Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
equation
 connect(samTri.y, lat.u)
   annotation (Line(points={{-70,40},{-66,40},{-66,42},{-62,42}},
                                                color={255,0,255}));
 connect(samTri.y, triSam.trigger) annotation (Line(points={{-70,40},{-68,40},{
         -68,56},{-50,56},{-50,58}}, color={255,0,255}));
 connect(triSam.y, gai.u)
   annotation (Line(points={{-38,70},{-22,70}}, color={0,0,127}));
 connect(lat.y, tim.u)
   annotation (Line(points={{-38,42},{-30,42},{-30,35.5},{-21,35.5}},
                                                color={255,0,255}));
  connect(greaterEqual.y, pre.u)
    annotation (Line(points={{61,60},{68,60}}, color={255,0,255}));
 connect(pre.y, lat.clr) annotation (Line(points={{92,60},{96,60},{96,20},{-66,
          20},{-66,36},{-62,36}},
                        color={255,0,255}));
 connect(lat.y, y) annotation (Line(points={{-38,42},{-32,42},{-32,-2},{120,-2}},
       color={255,0,255}));
 connect(uPLR, triSam.u) annotation (Line(points={{-120,0},{-96,0},{-96,70},{
          -62,70}},color={0,0,127}));
  connect(tim.y, greaterEqual.u1) annotation (Line(points={{2,38},{22,38},{22,
          60},{38,60}}, color={0,0,127}));
  connect(gai.y, greaterEqual.u2) annotation (Line(points={{2,70},{26,70},{26,
          52},{38,52}}, color={0,0,127}));
 annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
       coordinateSystem(preserveAspectRatio=false)));
end PLRToPulse;
