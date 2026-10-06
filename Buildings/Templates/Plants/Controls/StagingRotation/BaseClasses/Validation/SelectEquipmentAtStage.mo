within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.Validation;
model SelectEquipmentAtStage
  "Validation model for the equipment selection at a given stage"
  parameter Real staEqu[:,:] = [
    1, 0, 0;
    0, 1/2, 1/2;
    1, 1/2, 1/2;
    0, 1, 1;
    1, 1, 1]
    "Staging matrix – Equipment required for each stage";
  parameter Integer nSta = size(staEqu, 1)
    "Number of stages";
  parameter Integer nEqu = size(staEqu, 2)
    "Number of pieces of equipment";
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage
    selEquSta(final nEqu=nEqu)
                         "Select available equipment at stage"
              annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTra[nEqu,nSta](k={staEqu[
        i, j] for i in 1:nSta,j in 1:nEqu}) "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](each final
      nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[0,0,0,0; 1,1,0,0; 2,0,1,0; 3,0,0,1; 4,1,1,0; 5,0,1,1; 6,1,1,1; 7,0,0,
        0],
    timeScale=1,
    period=7)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable idxSta(
    table=[0,1; 1,2; 2,3; 3,4; 4,5; 5,4; 6,3],
    timeScale=1,
    period=7)
    "Stage index"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final
      nout=nEqu) "Replicate"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(staTra.y, reqEquSta.u)
    annotation (Line(points={{-68,0},{-12,0}}, color={0,0,127}));
  connect(reqEquSta.y, selEquSta.uEquSta)
    annotation (Line(points={{12,0},{38,0}}, color={0,0,127}));
  connect(u1AvaEqu.y, selEquSta.u1Ava) annotation (Line(points={{-68,-80},{20,-80},
          {20,-6},{38,-6}}, color={255,0,255}));
  connect(idxSta.y[1], intScaRep.u)
    annotation (Line(points={{-68,-40},{-52,-40}}, color={255,127,0}));
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-28,-40},{0,-40},{0,-12}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/BaseClasses/Validation/SelectEquipmentAtStage.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7.0,
      Tolerance=1e-06),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
                                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage\">
Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage</a>
in a configuration with one small unit and two lead/lag alternate units.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SelectEquipmentAtStage;
