import os, sys
import pandas as pd
# from Bio import AlignIO, Phylo
# from Bio.Phylo.TreeConstruction import *
# from Bio.Phylo.Consensus import *

# import analyze



def read_data():
    # read data from file
    filepath = os.path.normpath(os.path.join(coding_path, '..', 'Datenerhebung', 'spreadsheet.xlsx'))
    if not os.path.exists(filepath):
        raise Exception(f'Could not find spreadsheet\n(checked: {filepath})')
    # data = pd.read_excel('git/Seminararbeit-Balladen/Datenerhebung/spreadsheet.xlsx', sheet_name='Sheet2', index_col=0)
    data = pd.read_excel(filepath, sheet_name='Sheet2', index_col=0)

    # remove empty rows and columns
    cols = [0] + [c for c in data.columns if str(c).startswith('0.')]
    data.drop(index=0, columns=cols, inplace=True)

    # clean row names
    data.index = [str(i).split(' - ')[0].replace(' ', '_') for i in data.index]

    # Data should be good now
    # -----------------------
    # print(data)
    return data


def save_as_nexus(path, data):
    # build nexus file
    nex_01 = '''#NEXUS
BEGIN data;
Dimensions '''

    nex_02 = ''';
Format
datatype=standard
missing=?
gap=-
Symbols="0123456789";
Matrix
'''

    dimensions = f'ntax={data.shape[0]} nchar={data.shape[1]}'
    prefix = nex_01 + dimensions + nex_02
    matrix = get_matrix(data)
    suffix = '\n;\nEND;\n'

    nexus = prefix + matrix + suffix
    print(f'created nexus file ({data.shape[0]}x{data.shape[1]})')

    with open(path, 'w', encoding='utf-8') as f:
        f.write(nexus)
    print(f'Nexus stored at: {path}')


def get_matrix(df):
    rows = []
    for i, row in enumerate(df.values):
        name = df.index[i] + '____________'
        name = name[:12]
        rows.append(name + ' ' + ''.join(str(c) for c in row))
    return '\n'.join(rows)


# def make_tree(path):
#     # Read nexus file
#     alignment = AlignIO.read(path, "nexus")
#     # print(alignment)

#     # calculate distance matrix
#     calculator = DistanceCalculator('identity')
#     dm = calculator.get_distance(alignment)
#     # print(dm)

#     # construct trees from distance matrix
#     constructor = DistanceTreeConstructor()
#     upgmatree = constructor.upgma(dm)
#     nj = constructor.nj(dm)
#     Phylo.draw_ascii(upgmatree)
#     Phylo.draw_ascii(nj)
#     # Phylo.draw(upgmatree)
#     # Phylo.draw(nj)
#     # nj.ladderize()
#     # phx = upgmatree.as_phyloxml()
#     # print(f'\n\nXML:\n\n{phx}')
#     # Phylo.draw_ascii(phx)
#     # phx.ladderize()
#     # Phylo.draw(phx)
#     # Phylo.draw_graphviz(phx)

#     # scorer = ParsimonyScorer()
#     # searcher = NNITreeSearcher(scorer)
#     # constructor = ParsimonyTreeConstructor(searcher)
#     # pars_tree = constructor.build_tree(alignment)  # FIXME: Why does that not work?
#     # Phylo.draw_ascii(pars_tree)

#     constructor = DistanceTreeConstructor(calculator)
#     # trees = bootstrap_trees(alignment, 100, constructor)
#     # print(list(trees))
#     consensus_tree = bootstrap_consensus(alignment, 100, constructor, majority_consensus)
#     # print(consensus_tree)
#     Phylo.draw_ascii(consensus_tree)
#     # print(consensus_tree)
#     # import sys
#     # Phylo.write(consensus_tree, sys.stdout, 'newick')
#     # Phylo.draw(consensus_tree)



def main(path):
    global coding_path
    coding_path = path
    data = read_data()
    nex = os.path.join(path, 'data', 'nexus.nex')
    save_as_nexus(nex, data)
    # make_tree(nex)
    # rdata = analyze.load_data(nex)
    # rtrees = analyze.make_trees(rdata)


if __name__ == "__main__":
    try:
        main(os.path.dirname(__file__))
    except Exception as e:
        pass
