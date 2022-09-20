within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlantRemote
  "Base class for validation models with remote charging ability"
  extends PartialPlant;
  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha(
    final plaTyp=nom.plaTyp)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.TimeTable mSet_flow(table=[0,0; 900,0; 900,1; 1800,1;
        1800,-1; 2700,-1; 2700,1; 3600,1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isRemCha(t=1E-5)
    "Tank is being charged when the flow setpoint is negative"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.BooleanTable uAva(
    final table={900},
    final startValue=false)
    "Plant availability"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation
  connect(conRemCha.yPumSup, netCon.yPumSup)
    annotation (Line(points={{8,39},{8,11}}, color={0,0,127}));
  connect(conRemCha.yValSup, netCon.yValSup)
    annotation (Line(points={{12,39},{12,11}}, color={0,0,127}));
  connect(mSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-79,90},
          {-8,90},{-8,58},{-1,58}},   color={0,0,127}));
  connect(mSet_flow.y, isRemCha.u)
    annotation (Line(points={{-79,90},{-2,90}}, color={0,0,127}));
  connect(isRemCha.y, conRemCha.uRemCha) annotation (Line(points={{22,90},{28,90},
          {28,58},{22,58}}, color={255,0,255}));
  connect(conRemCha.uAva, uAva.y) annotation (Line(points={{22,54},{66,54},{66,
          90},{61,90}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This is a base class for the validation models
whose storage tank can be charged remotely.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialPlantRemote;
