describe shadow.users('root') do
  its(:passwords) { should_not include('*') }
end
