within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model SingleSpeed "Single speed water-cooled DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    dxCoo(final variableSpeedCoil=false,
          redeclare WaterCooled.Data.Generic.DXCoil datCoi,
          wetCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi,
                 appDewPt(redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per))),
          dryCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi,
                 appDryPt(redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per)))),
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi,
    eva(nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
                                             Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal,
                                             COP_nominal=datCoi.sta[nSta].nomVal.COP_nominal,
                                             SHR_nominal=datCoi.sta[nSta].nomVal.SHR_nominal,
                                             m_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
                                             TEvaIn_nominal=datCoi.sta[nSta].nomVal.TEvaIn_nominal,
                                             TConIn_nominal=datCoi.sta[nSta].nomVal.TConIn_nominal,
                                             phiIn_nominal=datCoi.sta[nSta].nomVal.phiIn_nominal,
                                             p_nominal=datCoi.sta[nSta].nomVal.p_nominal,
                                             tWet= datCoi.sta[nSta].nomVal.tWet,
                                             gamma=datCoi.sta[nSta].nomVal.gamma)),
    final use_mCon_flow=true,
    final nSta=1);

  Modelica.Blocks.Sources.Constant speRat(final k=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-56,58},{-44,70}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
protected
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-56,74},{-44,86}})));
equation
  connect(speRat.y, dxCoo.speRat) annotation (Line(
      points={{-43.4,64},{-40,64},{-40,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.on, on) annotation (Line(
      points={{-10,-62},{-92,-62},{-92,80},{-110,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,80},{-57.2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, dxCoo.stage) annotation (Line(
      points={{-43.4,80},{-34,80},{-34,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="sinSpeDX", Documentation(info="<html>
<p>
This model can be used to simulate a DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-140,132},{-96,112}},
          lineColor={0,0,255},
          textString="on")}));
end SingleSpeed;
