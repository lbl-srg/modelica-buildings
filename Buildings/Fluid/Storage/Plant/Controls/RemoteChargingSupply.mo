within Buildings.Fluid.Storage.Plant.Controls;
block RemoteChargingSupply
  "Control block for the supply pump and valves that allows remote charging"
  extends BaseClasses.PartialRemoteCharging(
    conPI_pumSup(reverseActing=true),
    conPI_valCha(reverseActing=false));

equation
  connect(andFroNet.u2, uRemCha) annotation (Line(points={{-22,22},{-40,22},{
          -40,30},{-110,30}},
                          color={255,0,255}));
  connect(notRemCha.y, andToNet.u2) annotation (Line(points={{-58,50},{-40,50},
          {-40,62},{-22,62}}, color={255,0,255}));
  connect(notRemCha.u, uRemCha) annotation (Line(points={{-82,50},{-90,50},{-90,
          30},{-110,30}}, color={255,0,255}));
  annotation (
  defaultComponentName="conRemChaSup",
    Documentation(revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>", info="<html>
<p>
This is a control block for the pump and valves in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
when remote charging of the storage plant is allowed.
This block implements the following control objectives:
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component in <code>NetworkConnection</code></th>
    <th>Control Objective</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump</td>
    <td>Outputs CHW from the plant;<br/>
        tracks the flow rate setpoint at the tank</td>
  </tr>
  <tr>
    <td>Valve in series with the pump</td>
    <td>Opens when the supply pump is on to allow flow,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Valve in parallel with the pump</td>
    <td>When the tank is being charged remotely,
        tracks a negative flow rate,<br/>
        otherwise it is closed</td>
  </tr>
</tbody>
</table>
</html>"),
    Icon(graphics={Text(
          extent={{-6,114},{42,22}},
          textColor={28,108,200},
          textString="S")}));
end RemoteChargingSupply;
