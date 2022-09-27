within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoopDebug "Open loop controller (output signals only)"
  parameter Integer nChi(start=1);

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus annotation (
      Placement(transformation(extent={{80,-20},{120,20}}), iconTransformation(
          extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet[nChi](each k=
        Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{40,-20},
            {80,20}}),   iconTransformation(extent={{-422,198},{-382,238}})));
equation
  connect(busChi, bus.chi) annotation (Line(
      points={{60,0},{100,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWatSupSet.y, busChi.TChiWatSupSet) annotation (Line(points={{12,-40},
          {40,-40},{40,0},{60,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoopDebug;
