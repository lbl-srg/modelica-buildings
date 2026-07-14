within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZoneControl "Zone control"
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block serves to change a single temperature setpoint based on the setpoint
change enabling signal input and the demand flexibility mode.
</p>
<p>
The input variable <code>TCurZonSet</code> represents the current value of the
temperature setpoint. The output variable <code>TComZonSet</code> commands the
temperature setpoint to take on a new value. The parameter <code>airConMod</code>
represents the air conditioning mode. <code>airConMod = true</code> represents the
heating mode, whereas <code>airConMod = false</code> represents the cooling mode.
<code>TCurZonSet</code> and <code>TComZonSet</code> must represent heating setpoints
when <code>airConMod = true</code>, and it must represent cooling setpoints when
<code>airConMod = false</code>.
</p>
<p>
The demand flexibility mode demFleMod can take values of 0 (pre-cool or pre-heat mode), 1 (default mode), 2 (load-shed mode), and 3 (load-rebound mode). 
</p>
<p>
This block conducts a setpoint change to output the commanded zone temperature setpoint TComZonSet as follows if the incremental setpoint change flag incSetCha = true:
</p>
</html>"));
end ZoneControl;
