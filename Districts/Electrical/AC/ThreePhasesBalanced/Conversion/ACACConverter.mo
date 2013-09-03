within Districts.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACACConverter "AC AC converter three phase balanced systems"
  extends Districts.Electrical.AC.OnePhase.Conversion.ACACConverter(
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
  annotation (Documentation(info="<html>
<p>
This is an AC AC converter, based on a power balance between both QS circuit sides.
The paramater <i>conversionFactor</i> defines the ratio between averaged the QS rms voltages.
The loss of the converter is proportional to the power transmitted at the second circuit side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the second circuit side.
Furthermore, reactive power on both QS side are set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;
