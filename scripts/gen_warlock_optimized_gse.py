from pathlib import Path
import runpy

ROOT = Path(__file__).resolve().parents[3]
module = runpy.run_path(str(ROOT / 'shared/docs/gen_all_class_optimized_gse.py'))
module['generate_classes'](['Warlock'])
