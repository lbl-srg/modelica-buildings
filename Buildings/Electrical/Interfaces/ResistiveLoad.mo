within Buildings.Electrical.Interfaces;
partial model ResistiveLoad "Partial model of a resistive load"
  extends Load;

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 14, 2015, by Marco Bonvini:<br/>
Created model to overcome limitation of OpenModelica in parsing the models
containing resistive loads.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a generic resistive load. This model is an extension of the base load model
<a href=\"Buildings.Electrical.Interfaces.PartialLoad\">
Buildings.Electrical.Interfaces.PartialLoad</a>.
</p>
</html>"));
end ResistiveLoad;
