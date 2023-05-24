within Buildings.Templates.ZoneEquipment.Components.Controls;
block OpenLoop "Open loop controller"
  extends
    Buildings.Templates.ZoneEquipment.Components.Interfaces.PartialControllerVAVBox(
      final typ=Buildings.Templates.ZoneEquipment.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamVAV(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiHea(k=1)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
equation
  /* Control point connection - start */
  connect(yDamVAV.y, bus.damVAV.y);
  connect(yCoiHea.y, bus.coiHea.y);
  /* Control point connection - end */
  annotation (
  defaultComponentName="ctl", Documentation(info="<html>
<p>
This is an open loop controller providing control inputs
for the templates within
<a href=\"modelica://Buildings.Templates.ZoneEquipment\">
Buildings.Templates.ZoneEquipment</a>.
It is mainly used for testing purposes.
</p>
</html>"));
end OpenLoop;
