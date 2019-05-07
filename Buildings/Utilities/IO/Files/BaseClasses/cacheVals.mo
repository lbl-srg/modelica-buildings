within Buildings.Utilities.IO.Files.BaseClasses;
function cacheVals
  "Function for caching results such that they can be written at destruction"
    input Buildings.Utilities.IO.Files.BaseClasses.JSONWriterObject ID "Json writer object id";
    input Real[:] varVals "Variable values";

    external "C" cacheVals(ID, varVals, size(varVals,1))
    annotation(Include=" #include \"jsonWriterInit.h\"",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(revisions="<html>
<ul>
<li>
April 15 2019, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Function for writing data to cache such that the results can be written at destruction.
</p>
</html>"));
end cacheVals;
