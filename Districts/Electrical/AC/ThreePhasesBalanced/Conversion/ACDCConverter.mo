within Districts.Electrical.AC.ThreePhasesBalanced.Conversion;
model ACDCConverter "AC DC converter"
  extends Districts.Electrical.AC.OnePhase.Conversion.ACDCConverter(
      redeclare Interfaces.Terminal_n terminal_n);

  annotation (Documentation(info="<html>
<p>
This is a converter from 3 phase AC to DC power, based on a power balance between both circuit sides.
All three AC phases will have the same power transmitted.
The paramater <i>conversionFactor</i> defines the ratio between the DC voltage and the averaged QS rms.
The loss of the converter is proportional to the power transmitted at the DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the DC circuit side.
Furthermore, reactive power on the AC side is set to <i>0</i>.
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
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
