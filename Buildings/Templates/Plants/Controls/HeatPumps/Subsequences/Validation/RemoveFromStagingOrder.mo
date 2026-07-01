within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.Validation;
model RemoveFromStagingOrder
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RemoveFromStagingOrder
    removeFromStagingOrder(nUni=4)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSor[4](k={3,1,2,4})
    "Units sorted by increasing runtime"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0,0,1,1,0; 1,1,1,0,0; 2,0,0,0,0; 3,1,1,1,1; 4,1,1,1,0; 5,0,0,0,1],
    timeScale=1,
    period=6) "Enable signal"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
equation
  connect(idxSor.y, removeFromStagingOrder.uIdxSor) annotation (Line(points={{
          -48,40},{-20,40},{-20,6},{-2,6}}, color={255,127,0}));
  connect(u1.y, removeFromStagingOrder.u1) annotation (Line(points={{-48,-20},{
          -20,-20},{-20,-6},{-2,-6}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RemoveFromStagingOrder;
