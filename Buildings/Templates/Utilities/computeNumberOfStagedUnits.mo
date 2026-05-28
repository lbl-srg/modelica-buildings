within Buildings.Templates.Utilities;
function computeNumberOfStagedUnits
  extends Modelica.Icons.Function;
  input Integer staHea "Heating stage";
  input Integer staCoo "Cooling stage";
  input Integer nHp "Number of HP units (excluding polyvalent HP)";
  input Integer nShc "Number of polyvalent HP units";
  output Integer nHpHea "Number of HP units in heating mode";
  output Integer nHpCoo "Number of HP units in cooling mode";
  output Integer nShcHea "Number of polyvalent HP units in heating-only mode";
  output Integer nShcCoo "Number of polyvalent HP units in cooling-only mode";
  output Integer nShcShc
    "Number of polyvalent HP units in simultaneous (SHC) mode";
  output Boolean is_feasible "True if the stage combination is achievable";
  protected
  Integer staShc "Minimum between cooling and heating stage";
  Integer staHeaRes "Residual heating stage count after SHC assignment";
  Integer staCooRes "Residual cooling stage count after SHC assignment";
  Integer nHpAva "HP units still available after heating assignment";
  Integer nShcAva "Polyvalent HP units still available after SHC assignment";
algorithm
  // Simultaneous load absorbed by polyvalent HP in SHC mode
  staShc := min(staHea, staCoo);
  nShcShc := min(staShc, nShc);
  // Simultaneous demand not covered by polyvalent HP spills into separate single-mode units
  staHeaRes := staHea - nShcShc;
  staCooRes := staCoo - nShcShc;
  // Residual single-mode heating: non-polyvalent first, then polyvalent
  nShcAva := nShc - nShcShc;
  nHpHea := min(staHeaRes, nHp);
  nShcHea := min(staHeaRes - nHpHea, nShcAva);
  // Residual single-mode cooling: non-polyvalent first, then polyvalent
  nHpAva := nHp - nHpHea;
  nHpCoo := min(staCooRes, nHpAva);
  nShcCoo := min(staCooRes - nHpCoo, nShcAva - nShcHea);
  // Feasibility: no unmet heating or cooling stage
  is_feasible := (staHeaRes - nHpHea - nShcHea == 0)
    and (staCooRes - nHpCoo - nShcCoo == 0);
annotation(Documentation(
  info="<html>
<p>
  For a heat pump plant with a mix of polyvalent and non-polyvalent units, 
  this function outputs the number of units required to run in each 
  operating mode, given the active heating and cooling stages.
</p>
<p>
  Fundamental assumption: in each pool of polyvalent and non-polyvalent units,
  all units must be equally sized.
  This translates into a stage index that equals the number of units 
  required to run: heating stage <i>#i</i> requires <i>i</i> units
  staged in heating mode.
</p>
<p>Staging priority:</p>
<ol>
  <li>
    Polyvalent HP in simultaneous heating and cooling mode to cover
    <code>min(staHea, staCoo)</code> stages of simultaneous load.
  </li>
  <li>Non-polyvalent HP for residual single-mode heating and cooling.</li>
  <li>
    Polyvalent HP in single mode for any remaining load beyond non-polyvalent
    HP capacity.
  </li>
</ol>
<p>
  If the combination of the heating and cooling stage exceeds fleet capacity,
  <code>is_feasible</code> is <code>false</code> and the output counts reflect 
  the maximum achievable assignment (i.e. all units committed).
</p>
</html>"));
end computeNumberOfStagedUnits;
