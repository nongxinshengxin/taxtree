
#' Title
#'
#' @param testid
#'
#' @return
#' @export
#'
#' @importFrom dplyr `%>%` filter
#' @examples
maketibble<-function(testid){
  data(nodes)
  idvector<-c()
  parentvector<-c()


  while (testid!="1"){
    set<-filter(nodes,ID==testid)
    idvector<-append(idvector,set$ID)
    parentvector<-append(parentvector,set$up)
    testid<-set$up
  }

  alllist<-list(idvector,parentvector)
  return(alllist)
}


#' Title
#' @description
#'
#' @param nodename
#' @param level a number,
#'
#' @return
#' @export
#'
#' @importFrom ggtree ggtree
#' @importFrom ape write.tree
#' @importFrom tidytree as.treedata as.phylo
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr `%>%` filter left_join select rename_with add_row distinct
#' @examples
find_Lineage<-function(nodename,level=3){
  data(names.dmp)
  data(nodes)
  nodename<-as.character(filter(names.dmp,name==nodename)[1])
  level1<-filter(nodes[1:2],up==nodename)
  level2<-level1%>%left_join(nodes[1:2],by=c("ID"="up"))%>%select(3,1)%>%rename_with(~c("ID","up"),1:2)%>%drop_na()
  level3<-level2%>%left_join(nodes[1:2],by=c("ID"="up"))%>%select(3,1)%>%rename_with(~c("ID","up"),1:2)%>%drop_na()
  level4<-level3%>%left_join(nodes[1:2],by=c("ID"="up"))%>%select(3,1)%>%rename_with(~c("ID","up"),1:2)%>%drop_na()
  level5<-level4%>%left_join(nodes[1:2],by=c("ID"="up"))%>%select(3,1)%>%rename_with(~c("ID","up"),1:2)%>%drop_na()

  if (level==1){
    tax_child2parent<-level1%>%add_row(tibble(ID=as.numeric(nodename),up=as.numeric(nodename)))
  }else if(level==2){
    tax_child2parent<-level1%>%add_row(level2)%>%add_row(tibble(ID=as.numeric(nodename),up=as.numeric(nodename)))
  }else if(level==3){
    tax_child2parent<-level1%>%add_row(level2)%>%add_row(level3)%>%add_row(tibble(ID=as.numeric(nodename),up=as.numeric(nodename)))
  }else if(level==4){
    tax_child2parent<-level1%>%add_row(level2)%>%add_row(level3)%>%add_row(level4)%>%add_row(tibble(ID=as.numeric(nodename),up=as.numeric(nodename)))
  }else if(level==5){
    tax_child2parent<-level1%>%add_row(level2)%>%add_row(level3)%>%add_row(level4)%>%add_row(level5)%>%add_row(tibble(ID=as.numeric(nodename),up=as.numeric(nodename)))
  }
  tax_child2parent<-tibble(child_id=tax_child2parent$ID,parent_id=tax_child2parent$up)%>%distinct()%>%left_join(names.dmp,by=c("child_id"="ID"))

  tibble_tree<-tibble(parent="0",node=tax_child2parent$name,label=tax_child2parent$name)
  for (i in 1:nrow(tax_child2parent)){
    tibble_tree[i,1]<-tax_child2parent[which(tax_child2parent$child_id==as.character(tax_child2parent[i,2])),3]
  }

  tibble_tree<-mutate(tibble_tree,parent=gsub("[\\'\\(\\)]*","",tibble_tree$parent),
                      node=gsub("[\\'\\(\\)]*","",tibble_tree$node),
                      label=gsub("[\\'\\(\\)]*","",tibble_tree$label))

  tree<-as.phylo(tibble_tree)
  treetext<-write.tree(tree,"")
  tree<-read.tree(text=treetext)

  return(tree)
}



#' Title
#'
#' @param file
#' @param header
#'
#' @return
#' @export
#'
#' @importFrom tidytree as.treedata as.phylo
#' @importFrom readr read_delim
#' @importFrom dplyr `%>%` filter left_join select rename_with add_row distinct
#' @importFrom tibble tibble
#' @importFrom ape write.tree
#' @importFrom ggtree ggtree
#'
#' @examples
make_Taxtree<-function(file,header=FALSE){
  data(names.dmp)
  data(nodes)
  listfile<-read_delim(file=file,col_names = header,delim = "\t")%>%rename_with(~"name",1)
  name2id<-listfile%>%left_join(names.dmp)
  emptyid<-c()
  emptyup<-c()
  for (i in 1:nrow(name2id)){
    alllist<-maketibble(as.character(name2id[i,2]))
    if (length(emptyid)==0){
      emptyid<-alllist[[1]]
      emptyup<-alllist[[2]]
    }else{
      emptyid<-append(emptyid,alllist[[1]])
      emptyup<-append(emptyup,alllist[[2]])
    }
  }
  tax_child2parent<-tibble(child_id=emptyid,parent_id=emptyup)%>%distinct()%>%left_join(names.dmp,by=c("child_id"="ID"))

  tibble_tree<-tibble(parent="0",node=tax_child2parent$name,label=tax_child2parent$name)
  for (i in 1:nrow(tax_child2parent)){
    if (length(which(tax_child2parent$child_id==as.character(tax_child2parent[i,2])))!=0){
      tibble_tree[i,1]<-tax_child2parent[which(tax_child2parent$child_id==as.character(tax_child2parent[i,2])),3]
    }else{
      tibble_tree[i,1]<-tibble_tree[i,2]
    }
  }

  tibble_tree<-mutate(tibble_tree,parent=gsub("[\\'\\(\\)]*","",tibble_tree$parent),
                      node=gsub("[\\'\\(\\)]*","",tibble_tree$node),
                      label=gsub("[\\'\\(\\)]*","",tibble_tree$label))

  tree<-as.phylo(tibble_tree)
  treetext<-write.tree(tree,"")
  tree<-read.tree(text=treetext)

  return(tree)
}



#' Title
#'
#' @param treefile
#' @param clade_group
#' @param module
#'
#' @return a figure as ggtree object
#' @export
#'
#' @import ggtree
#'
#' @examples
plot_taxTree<-function(treefile,clade_group=c(),module=1){
  modulevector<-c("rectangular","ellipse","circular")
  if (length(clade_group)==0){
    p0<-ggtree(treefile, branch.length = 'none', layout = modulevector[module],ladderize=F,size=0.1) +
      geom_tiplab(fontface = "bold.italic",size=3.5)+
      xlim(c(0, 35))
  }else{
    treefile <- groupClade(treefile, .node = clade_group)
    p0<-ggtree(treefile, aes(color=group), branch.length = 'none', layout = modulevector[module],ladderize=F,size=0.1) +
      geom_tiplab(fontface = "bold.italic",size=3.5)+
      xlim(c(0, 35))+theme_inset(legend.position = "none")
  }
  return(p0)
}


#' Title
#'
#' @param tree
#' @param output
#'
#' @return
#' @export
#'
#' @importFrom ape write.tree
#'
#' @examples
write_taxTree<-function(tree,output){
  write.tree(tree,file = output)
}

