within Buildings.Fluid.Storage.Plant.Controls;
block RemoteChargingReturn
  "Control block for the return pump and valves that allows remote charging"
  extends BaseClasses.PartialRemoteCharging(
    conPI_pumSup(reverseActing=false),
    conPI_valCha(reverseActing=true));

equation
  connect(uRemCha, andToNet.u2) annotation (Line(points={{-110,30},{-90,30},{
          -90,70},{-40,70},{-40,62},{-22,62}},
                             color={255,0,255}));
  connect(notRemCha.u, uRemCha) annotation (Line(points={{-82,50},{-90,50},{-90,
          30},{-110,30}}, color={255,0,255}));
  connect(notRemCha.y, andFroNet.u2) annotation (Line(points={{-58,50},{-40,50},
          {-40,22},{-22,22}}, color={255,0,255}));
  annotation (
  defaultComponentName="conRemChaRet",
    Documentation(revisions="<html>
<ul>
<li>
November 7, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>", info="<html>
<p>
[fixme: Documentation pending.]
</p>
</html>"),
Icon(graphics={Text(
          extent={{-6,114},{42,22}},
          textColor={28,108,200},
          textString="R")}));
end RemoteChargingReturn;
