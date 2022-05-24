from graphviz import Source

path = 'test2.dot'
s = Source.from_file(path)
print(s.source)

s.render('abcd.gv', format='jpg', view=True)