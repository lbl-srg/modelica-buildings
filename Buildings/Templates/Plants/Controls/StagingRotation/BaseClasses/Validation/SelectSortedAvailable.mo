within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.Validation;
model SelectSortedAvailable
  "Validation model for the equipment selection at a given stage, given a priority order"
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
  parameter Integer nEquAlt = 2
    "Number of lead/lag alternate units";
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectSortedAvailable
    selSorAva(final nEqu=nEqu, final nEquAlt=nEquAlt)
    "Select available equipment by priority order"
              annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTra[nEqu,nSta](k={staEqu[
        i, j] for i in 1:nSta,j in 1:nEqu}) "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](each final
      nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[0,0,0,0; 1,1,0,0; 2,0,1,0; 3,0,0,1; 4,1,1,0; 5,0,1,1; 6,1,1,1; 7,0,0,
        0],
    timeScale=1,
    period=7) "Equipment available signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable idxSta(
    table=[0,1; 1,2; 5,3],
    timeScale=1,
    period=7)
    "Stage index"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final
      nout=nEqu) "Replicate"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uIdxSor(
    table=[0,2,3; 4,3,2; 6,2,3],
    timeScale=1,
    period=7) "Equipment index sorted by priority"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage
    selEquSta(final nEqu=nEqu)
    "Calculate number of required units at each stage"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(staTra.y, reqEquSta.u)
    annotation (Line(points={{-68,0},{-32,0}}, color={0,0,127}));
  connect(u1AvaEqu.y,selSorAva. u1Ava) annotation (Line(points={{-68,-80},{60,-80},
          {60,-6},{68,-6}}, color={255,0,255}));
  connect(idxSta.y[1], intScaRep.u)
    annotation (Line(points={{-68,-40},{-52,-40}}, color={255,127,0}));
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-28,-40},{-20,-40},{-20,-12}},
                                                         color={255,127,0}));
  connect(uIdxSor.y, selSorAva.uIdxSor) annotation (Line(points={{-68,60},{60,60},
          {60,6},{68,6}}, color={255,127,0}));
  connect(reqEquSta.y, selEquSta.uEquSta)
    annotation (Line(points={{-8,0},{18,0}}, color={0,0,127}));
  connect(u1AvaEqu.y, selEquSta.u1Ava) annotation (Line(points={{-68,-80},{0,
          -80},{0,-6},{18,-6}}, color={255,0,255}));
  connect(selEquSta.nAlt, selSorAva.n)
    annotation (Line(points={{42,4},{60,4},{60,0},{68,0}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/BaseClasses/Validation/SelectSortedAvailable.mos"
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
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectSortedAvailable\">
Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectSortedAvailable</a>
in a configuration with one small unit and two lead/lag alternate units.
</p>
</html>"));
end SelectSortedAvailable;
