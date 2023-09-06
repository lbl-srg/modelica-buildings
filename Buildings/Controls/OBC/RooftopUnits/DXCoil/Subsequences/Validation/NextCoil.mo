within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model NextCoil
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.NextCoil nextCoil(nCoi=4)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  CDL.Integers.Sources.Constant conInt[4](k=coiInd)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  CDL.Routing.IntegerExtractor extIndInt(nin=4)
    annotation (Placement(transformation(extent={{-14,60},{6,80}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  ChangeStatus chaSta(nCoi=4)
    annotation (Placement(transformation(extent={{68,10},{90,30}})));
  CDL.Conversions.BooleanToInteger booToInt[4]
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CDL.Integers.MultiSum mulSumInt(nin=5)
    annotation (Placement(transformation(extent={{-32,30},{-12,50}})));
  CDL.Logical.Pre pre[4]
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  CDL.Logical.Sources.SampleTrigger samTri(period=60, shift=10)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  CDL.Logical.Pre pre2
                     [4]
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=10, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  CDL.Integers.Sources.Constant conInt1(k=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Logical.TrueDelay truDel(delayTime=10)
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  CDL.Logical.TrueFalseHold truFalHol2(trueHoldDuration=10, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
protected
  parameter Integer nCoi=4;
  parameter Integer coiInd[nCoi]={i for i in 1:nCoi}
    "DX coil index, {1,2,...,n}";
equation
  connect(conInt.y, extIndInt.u)
    annotation (Line(points={{-18,70},{-16,70}}, color={255,127,0}));
  connect(extIndInt.y, nextCoil.uNexCoi) annotation (Line(points={{8,70},{10,70},
          {10,26},{18,26}}, color={255,127,0}));
  connect(con.y, nextCoil.uDXCoiAva[1]) annotation (Line(points={{-68,10},{-60,
          10},{-60,16.5},{18,16.5}},
                                 color={255,0,255}));
  connect(con.y, nextCoil.uDXCoiAva[3]) annotation (Line(points={{-68,10},{-60,
          10},{-60,18.5},{18,18.5}},
                                 color={255,0,255}));
  connect(con.y, nextCoil.uDXCoiAva[4]) annotation (Line(points={{-68,10},{-60,
          10},{-60,19.5},{18,19.5}},
                                 color={255,0,255}));
  connect(booToInt.y, mulSumInt.u[1:4]) annotation (Line(points={{-38,40},{-36,40},
          {-36,37.2},{-34,37.2}},   color={255,127,0}));
  connect(mulSumInt.y, extIndInt.index)
    annotation (Line(points={{-10,40},{-4,40},{-4,58}}, color={255,127,0}));
  connect(nextCoil.yNexCoi, chaSta.uNexDXCoi)
    annotation (Line(points={{42,16},{50,16},{50,16},{66,16}},
                                               color={255,127,0}));
  connect(nextCoil.yNexCoi, chaSta.uLasDXCoi) annotation (Line(points={{42,16},
          {60,16},{60,12},{66,12}},color={255,127,0}));
  connect(chaSta.yDXCoi, pre.u) annotation (Line(points={{92,20},{96,20},{96,0},
          {64,0},{64,-20},{68,-20}}, color={255,0,255}));
  connect(pre.y, chaSta.uDXCoil) annotation (Line(points={{92,-20},{98,-20},{98,
          40},{60,40},{60,20},{66,20}}, color={255,0,255}));
  connect(nextCoil.yStaUp, chaSta.uNexDXCoiSta) annotation (Line(points={{42,20},
          {56,20},{56,28},{66,28}}, color={255,0,255}));
  connect(con.y, chaSta.uLasDXCoiSta) annotation (Line(points={{-68,10},{-60,10},
          {-60,-16},{62,-16},{62,25},{66,25}}, color={255,0,255}));
  connect(pre.y, nextCoil.uDXCoi) annotation (Line(points={{92,-20},{98,-20},{
          98,40},{14,40},{14,14},{18,14}},
                                        color={255,0,255}));
  connect(pre2.y, booToInt.u)
    annotation (Line(points={{-68,40},{-62,40}}, color={255,0,255}));
  connect(pre2.u, nextCoil.yDXCoiInt) annotation (Line(points={{-92,40},{-96,40},
          {-96,-26},{52,-26},{52,24},{42,24}}, color={255,0,255}));
  connect(conInt1.y, mulSumInt.u[5]) annotation (Line(points={{-58,70},{-46,70},
          {-46,34.4},{-34,34.4}}, color={255,127,0}));
  connect(samTri.y, nextCoil.uStaUp) annotation (Line(points={{-38,-60},{0,-60},
          {0,22},{18,22}}, color={255,0,255}));
  connect(samTri.y, truFalHol1.u) annotation (Line(points={{-38,-60},{0,-60},{0,
          -80},{18,-80}}, color={255,0,255}));
  connect(pre[3].y, truDel.u) annotation (Line(points={{92,-20},{98,-20},{98,-40},
          {108,-40}}, color={255,0,255}));
  connect(truDel.y, nextCoil.uDXCoiAva[2]) annotation (Line(points={{132,-40},{
          136,-40},{136,-60},{10,-60},{10,17.5},{18,17.5}},
                                                        color={255,0,255}));
  connect(nextCoil.yStaUp, truFalHol2.u) annotation (Line(points={{42,20},{56,
          20},{56,60},{58,60}},
                            color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
          Ellipse(lineColor = {75,138,73},
              fillColor={255,255,255},
              fillPattern = FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
              fillColor = {75,138,73},
              pattern = LinePattern.None,
              fillPattern = FillPattern.Solid,
              points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,100}})),
    experiment(
      StopTime=300,
      Interval=1,
      __Dymola_Algorithm="Cvode"));
end NextCoil;
