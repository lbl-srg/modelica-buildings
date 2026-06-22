within Buildings.Templates.Plants.Controls.StagingRotation;
block StageAvailability
  "Compute stage availability"
  parameter Boolean have_php = false
    "Set to true for plants with polyvalent heat pumps"
    annotation (Evaluate=true);
  parameter Real staEqu[:,:](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta=if have_php then
    integer((1 + sqrt(1 + 4*size(staEqu, 1))) / 2) - 1
    else size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEqu=size(staEqu, 2)
    "Number of equipment"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nSta]
    "Stage available signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant matStaEqu[nSta, nEqu](
    final k=staEqu) if not have_php
    "Staging matrix"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(
    final nin=nEqu,
    final nout=nSta)
    "Replicate equipment available signal"
    annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isAva[nSta](each final nin=3)
    "Return true if stage available"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqual isReqAltAvaGreReq[nSta]
    "Return true if number of required available equipment higher than number of required equipment"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Utilities.CountTrue nReqOrAltAva[nSta](each final nin=nEqu)
    "Number of units required (with or without lead/lag alternate) and available"
    annotation (Placement(transformation(extent={{-8,30},{12,50}})));
  BaseClasses.SelectEquipmentAtStage selEquSta[nSta](each final nEqu=nEqu)
    "Select equipment at stage"
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaOpp(final min=0,
      final max=nSta) if have_php
                      "Stage index of opposite mode" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),   iconTransformation(
          extent={{-140,40},{-100,80}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extSta(final sta=staEqu, final
      is_transpose=false) if have_php
    "Extract staging matrix for the opposite mode stage index"
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold      notZer[nSta](each final
            t=0)
    "True if the number of units required (with or without lead/lag alternate) is nonzero"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Utilities.CountTrue nReqAndAva[nSta](each final nin=nEqu)
    "Number of units required (without lead/lag alternate) and available"
    annotation (Placement(transformation(extent={{-10,-38},{10,-18}})));
  Buildings.Controls.OBC.CDL.Integers.Equal allReqAva[nSta]
    "True if all units required (without lead/lag alternate) are available"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
equation
  connect(selEquSta.y1ReqOrAltAndAva, nReqOrAltAva.u1) annotation (Line(points={{-30,-4},
    {-20,-4},{-20,40},{-10,40}},          color={255,0,255}));
  connect(selEquSta.y1ReqAndAva, nReqAndAva.u1) annotation (Line(points={{-30,0},
          {-22,0},{-22,-28},{-12,-28}},         color={255,0,255}));
  connect(isAva.y, y1)
    annotation (Line(points={{92,0},{120,0}}, color={255,0,255}));
  connect(u1Ava, booVecRep.u)
    annotation (Line(points={{-120,-40},{-90,-40}}, color={255,0,255}));
  connect(matStaEqu.y, selEquSta.uEquSta) annotation (Line(points={{-66,0},{-54,
          0}},                    color={0,0,127}));
  connect(booVecRep.y, selEquSta.u1Ava) annotation (Line(points={{-66,-40},{-60,
          -40},{-60,-6},{-54,-6}},     color={255,0,255}));
  connect(selEquSta.nTot, isReqAltAvaGreReq.u2) annotation (Line(points={{-30,8},
          {20,8},{20,12},{28,12}}, color={255,127,0}));
  connect(nReqOrAltAva.y, isReqAltAvaGreReq.u1)
    annotation (Line(points={{14,40},{20,40},{20,20},{28,20}},
                                               color={255,127,0}));
  connect(extSta.y, selEquSta.uEquSta) annotation (Line(points={{-66,40},{-60,
          40},{-60,0},{-54,0}}, color={0,0,127}));
  connect(notZer.y, isAva.u[1]) annotation (Line(points={{52,60},{60,60},{60,
          -2.33333},{68,-2.33333}},
         color={255,0,255}));
  connect(isReqAltAvaGreReq.y, isAva.u[2]) annotation (Line(points={{52,20},{60,
          20},{60,0},{68,0}},
    color={255,0,255}));
  connect(allReqAva.y, isAva.u[3]) annotation (Line(points={{52,-20},{60,-20},{
          60,2.33333},{68,2.33333}},
         color={255,0,255}));
  connect(nReqAndAva.y, allReqAva.u2) annotation (Line(points={{12,-28},{28,-28}},
                              color={255,127,0}));
  connect(selEquSta.nReq, allReqAva.u1) annotation (Line(points={{-30,6},{20,6},
          {20,-20},{28,-20}}, color={255,127,0}));
  connect(selEquSta.nTot, notZer.u) annotation (Line(points={{-30,8},{-22,8},{
          -22,60},{28,60}}, color={255,127,0}));
  connect(uStaOpp, extSta.u)
    annotation (Line(points={{-120,40},{-90,40}}, color={255,127,0}));
  annotation (
    defaultComponentName="avaSta",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}}, grid={2,2})),
    Documentation(
      info="<html>
<p>
A stage is deemed available if all of the following are true:
</p>
<ul>
<li>
Each unit required to run at that stage without lead/lag alternate is available.
</li>
<li>
The number of units required to run at that stage &ndash;
with or without lead/lag alternate &ndash; that are available is greater
than or equal to the number of units required to run at that stage.
</li>
<li>
The number of units required to run at that stage &ndash;
with or without lead/lag alternate &ndash; is nonzero.
This condition is used by
<a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters\">
Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.StagingParameters</a>
to encode that a stage is not feasible.
</li>
</ul>
<p>
Otherwise, the stage is deemed unavailable.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageAvailability;
