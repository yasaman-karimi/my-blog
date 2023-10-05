from django.shortcuts import render

def post_list(request):
    return render(request,'blogpage/post_list.html',{})